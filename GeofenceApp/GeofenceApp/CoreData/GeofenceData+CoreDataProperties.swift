//
//  GeofenceData+CoreDataProperties.swift
//  GeofenceApp
//
//  Created by Vaibhav on 12/11/23.
//
//

import Foundation
import CoreData


extension GeofenceData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GeofenceData> {
        return NSFetchRequest<GeofenceData>(entityName: "GeofenceData")
    }

    @NSManaged public var eventType: String?
    @NSManaged public var identifier: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var timestamp: Double

}

extension GeofenceData : Identifiable {

}
