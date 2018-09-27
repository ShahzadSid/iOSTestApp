//
//  DetailsViewController.swift
//  Test App
//
//  Created by Muhammad Shahzad on 9/23/18.
//  Copyright © 2018 Muhammad Shahzad. All rights reserved.
//

import UIKit
import GoogleMaps

class DetailsViewController: UIViewController,GMSMapViewDelegate {

    var selectedDelivery:Delivery?
    let marker = GMSMarker()
    
    private var mapView : GMSMapView = {
        let mView = GMSMapView()
        return mView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        self.view.addSubview(mapView)
        let guide = self.view.safeAreaLayoutGuide
        mapView.anchor(top: guide.topAnchor, left: guide.leftAnchor, bottom: guide.bottomAnchor, right: guide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        if selectedDelivery != nil {
            let camera = GMSCameraPosition.camera(withLatitude: (selectedDelivery?.location?.lat)!, longitude: (selectedDelivery?.location?.lng)!, zoom: 15.0)
            
            mapView.camera = camera
            showMarker(position:camera.target)
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func  showMarker(position: CLLocationCoordinate2D) {
        marker.position = position
        marker.title = selectedDelivery?.descriptionField
        marker.snippet = selectedDelivery?.location?.address
        marker.map = mapView
        marker.isDraggable = true
    }
    
}
