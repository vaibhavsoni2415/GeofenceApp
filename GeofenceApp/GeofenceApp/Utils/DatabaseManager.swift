//
//  DatabaseManager.swift
//  GeoFenceTestApp
//
//  Created by Vaibhav on 12/11/23.
//

import Foundation
import UIKit
import CoreData

class DataBaseHelper {
    
    static let shared = DataBaseHelper()
    var context: NSManagedObjectContext!
    var operationQueue : OperationQueue {
        let queue = OperationQueue.init()
        queue.maxConcurrentOperationCount = 1
        return queue
    }
    
    private init(){
        DispatchQueue.main.async {
            self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        }
    }

    func loadDB(){
    }
    
    // MARK: - Save changes
    @discardableResult
    func saveContext ()->Bool {
        var isSaved  = false
        
        if (context.hasChanges)
        {
            do {
                try  context.save()
                isSaved = true
            } catch
            {
                return isSaved
                
            }
        }
        
        return isSaved
    }
    
    func saveGeofenceData(geofenceData: GeofenceStruct) {
        // Save data to Core Data
        operationQueue.addOperation {
            let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateMOC.parent = self.context
            privateMOC.perform {

                let geofenceEvent = GeofenceData(context: privateMOC)
                geofenceEvent.identifier = geofenceData.identifier
                geofenceEvent.timestamp = geofenceData.timestamp
                geofenceEvent.latitude = geofenceData.latitude
                geofenceEvent.longitude = geofenceData.longitude
                geofenceEvent.eventType = geofenceData.entered ? "Enter"  : "Exit"

                do {
                    try privateMOC.save()
                    let result = self.context.performAndWait {
                        self.saveContext()
                    }
                    debugPrint(result)
                } catch {
                    debugPrint("Failure to save context: \(error)")
                }
            }
        }
    }
    
    func fetchAllGeofenceEventsData() -> [GeofenceData] {
        var events = [GeofenceData]()
        let fetchRequest = GeofenceData.fetchRequest()
        do{
            events = try context.fetch(fetchRequest)
        }catch{
            
        }
        return events
    }


}


// MARK: - Managed Object Context
extension NSManagedObject {
    
    class func anEntityName()-> String! {
        return  NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    class func create(context:NSManagedObjectContext = DataBaseHelper.shared.context) -> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: self.anEntityName(), into: context);
    }
    
    func dictionary(object:NSManagedObject)->[String:Any]  {
        let keys = Array(object.entity.attributesByName.keys)
        let dict = object.dictionaryWithValues(forKeys: keys)
        return dict
    }
    
    func delete() {
        let managedObjectContext = DataBaseHelper.shared.context
        managedObjectContext?.performAndWait { () -> Void in
            managedObjectContext?.delete(self)
        }
    }
    
}

// MARK: - Database table entities
struct DBEntities {
    static let geofenceData = "GeofenceData"
}
