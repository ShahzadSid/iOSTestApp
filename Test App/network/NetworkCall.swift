//
//  NetworkCall.swift
//  Test App
//
//  Created by Muhammad Shahzad on 9/21/18.
//  Copyright © 2018 Muhammad Shahzad. All rights reserved.
//

import Foundation
import Alamofire

class NetworkCall {
    
    //MARK: - Properties
    static let instance = NetworkCall()
    var remoteDataReadyDelegate:RemoteDataReadyDelegate?
    
    //MARK: - Private Init (Singleton)
    private init () { }
    
    //MARK: - Method To Make A GET Web Service Requset
    func requestWithGET(requestUrl:String){
        Alamofire.request(requestUrl, method: .get, encoding: URLEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success:
                if response.data != nil {
                    if self.remoteDataReadyDelegate != nil {
                        self.remoteDataReadyDelegate?.onRemoteDataReady(remoteData: response.data!)
                    }
                }
                break
            case .failure:
                if self.remoteDataReadyDelegate != nil {
                    self.remoteDataReadyDelegate?.onRemoteDataError()
                }
                break
            }
        }
    }
    
}
