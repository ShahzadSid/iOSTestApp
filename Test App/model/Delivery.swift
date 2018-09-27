//
//  Delivery.swift
//  Test App
//
//  Created by Muhammad Shahzad on 9/24/18.
//  Copyright © 2018 Muhammad Shahzad. All rights reserved.
//

import Foundation
import CoreData

class Delivery: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case descriptionField = "description"
        case imageUrl = "imageUrl"
        case id = "id"
        case location = "location"
    }
    
    // MARK: - Core Data Managed Object
    @NSManaged var descriptionField: String?
    @NSManaged var imageUrl: String?
    @NSManaged var id: Int64
    @NSManaged var location: Location?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Delivery> {
        return NSFetchRequest<Delivery>(entityName: DELIVERY_CORE_DATA_NAME)
    }
    
    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {

        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: DELIVERY_CORE_DATA_NAME, in: managedObjectContext) else {
                fatalError("Failed to decode User")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.descriptionField = try container.decodeIfPresent(String.self, forKey: .descriptionField)
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        self.id = try container.decodeIfPresent(Int64.self, forKey: .id)!
        self.location = try container.decodeIfPresent(Location.self, forKey: .location)!
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(descriptionField, forKey: .descriptionField)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(id, forKey:.id)
        try container.encode(location, forKey:.location)
    }
}
