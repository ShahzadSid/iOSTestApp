//
//  AllDeliveriesTableViewController.swift
//  Test App
//
//  Created by Muhammad Shahzad on 9/21/18.
//  Copyright © 2018 Muhammad Shahzad. All rights reserved.
//

import UIKit
import CoreData

class AllDeliveriesTableViewController: UITableViewController,RemoteDataReadyDelegate,NSFetchedResultsControllerDelegate {
    
    //MARK:- Properties
    var allDeliveries : [Delivery]  = [Delivery]()
    let activityView = UIActivityIndicatorView(style: .gray)
    var managedObjectContext: NSManagedObjectContext? = nil
    var loadCoreData = true
    let limit = 20
    
    //MARK:- Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(DeliveryTableViewCell.self, forCellReuseIdentifier: CELL_ID)
        activityView.center = self.view.center
        activityView.startAnimating()
        self.view.addSubview(activityView)
        
        //Load Data From Server If Connection is Avaiable, if not load from core data
        loadDataFromServerOrCoreData(offset: allDeliveries.count, limit: limit)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = APP_TITLE
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allDeliveries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as? DeliveryTableViewCell
        cell?.delivery = allDeliveries[indexPath.row]
        return cell!
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsViewController = DetailsViewController()
        detailsViewController.selectedDelivery = allDeliveries[indexPath.row]
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex)-1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            //If
            let spinner = UIActivityIndicatorView(style: .gray)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            
            self.tableView.tableFooterView = spinner
            self.tableView.tableFooterView?.isHidden = false
            
            //Load Data From Server If Connection is Avaiable, if not load from core data
            loadDataFromServerOrCoreData(offset: allDeliveries.count, limit: limit)
            
        }
    }
}

//Mark:- Function That Will Load Data From Server Or Core Data Depending Upon the Network Connection
extension AllDeliveriesTableViewController {
    
    func loadDataFromServerOrCoreData(offset:Int,limit:Int) {
        if CheckInternet.isConnectedToNetwork() { //Load Deliveries Data From Server And Save It In Core Data
            if(offset == 0) { //For the first time delete all previous records
                clearStorage()
            }
            loadDeliveriesData(offset: offset, limit: limit) // Load first 20 records
        }else { // Load Deliveries Data Core Data
            if (loadCoreData) {
                loadCoreData = false
                fetchFromStorage(offset: offset, limit: limit)
            }
        }
    }
    
}

//MARK:-  Network Calls and Delegates Methods
extension AllDeliveriesTableViewController {
 
    //Function to load deliveries data from the server
    func loadDeliveriesData(offset:Int,limit:Int) {
        NetworkCall.instance.remoteDataReadyDelegate = self
        NetworkCall.instance.requestWithGET(requestUrl: NETWORK_URL+"?offset=\(offset)&limit=\(limit)")
    }
    
    //On Success Full Request Of Deliveries Datr
    func onRemoteDataReady(remoteData: Data) {
        
        do {
            let context = self.managedObjectContext!
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.context!] = context
            
            let response:[Delivery] = try decoder.decode([Delivery].self, from: remoteData)
            activityView.stopAnimating()
            allDeliveries.append(contentsOf: response)
            tableView.reloadData()
            try context.save()
            
        }catch {
            showAlert(title: NETWORK_ERROR_TITLE, message: error.localizedDescription)
        }
    }
    //On Unsuccess Full Request Of Deliveries Data
    func onRemoteDataError() {
        showAlert(title: NETWORK_ERROR_TITLE, message: NETWORK_ERROR_MESSAGE)
    }
    
}

//MARK:- Core Data Function to Get and Remove Deliveries
extension AllDeliveriesTableViewController {
   
    //Get Deliveries From The Core Data
    func fetchFromStorage(offset:Int,limit:Int) {
        let fetchRequest = NSFetchRequest<Delivery>(entityName: DELIVERY_CORE_DATA_NAME)
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = limit
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let users = try self.managedObjectContext!.fetch(fetchRequest)
            if users.count > 0 {
                allDeliveries.append(contentsOf: users)
                if (!loadCoreData) {
                    self.tableView.reloadData()
                    self.activityView.stopAnimating()
                    loadCoreData = true
                }
            }else {
                showAlert(title: CORE_DATA_ERROR, message: NO_MORE_DELIVERIES)
            }
        } catch let error {
            showAlert(title: CORE_DATA_ERROR, message: error.localizedDescription)
            
        }
    }
    //Clear All Records From The Core Data
    func clearStorage() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DELIVERY_CORE_DATA_NAME)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try self.managedObjectContext!.execute(batchDeleteRequest)
        } catch let error as NSError {
            showAlert(title: CORE_DATA_ERROR, message: error.localizedDescription)
        }
    }
}
