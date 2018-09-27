//
//  Protocols.swift
//  Test App
//
//  Created by Muhammad Shahzad on 9/21/18.
//  Copyright © 2018 Muhammad Shahzad. All rights reserved.
//

import Foundation

//MARK:- Remote Data Ready Protocol
protocol RemoteDataReadyDelegate {
    func onRemoteDataReady(remoteData:Data)
    func onRemoteDataError()
}
