//
//  Location.swift
//  Test App
//
//  Created by Muhammad Shahzad on 9/24/18.
//  Copyright © 2018 Muhammad Shahzad. All rights reserved.
//

import Foundation
import CoreData

class Location : NSManagedObject, Codable {
    
    @NSManaged var address: String?
    @NSManaged var lat: Double
    @NSManaged var lng: Double
    
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case lat = "lat"
        case lng = "lng"
    }
    
    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {
        
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: LOCATION_CORE_DATA_NAME, in: managedObjectContext) else {
                fatalError("Failed to decode User")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.address = try container.decodeIfPresent(String.self, forKey: .address)
        self.lat = try container.decodeIfPresent(Double.self, forKey: .lat)!
        self.lng = try container.decodeIfPresent(Double.self, forKey: .lng)!
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(address, forKey: .address)
        try container.encode(lat, forKey: .lat)
        try container.encode(lng, forKey:.lng)
    }
    
}
