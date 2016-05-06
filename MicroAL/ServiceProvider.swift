//
//  ServiceProvider.swift
//  MicroAL
//
//  Created by Christopher Prince on 5/5/16.
//  Copyright © 2016 Spastic Muffin, LLC. All rights reserved.
//

import Foundation
import CoreData
import SMCoreLib

class ServiceProvider: NSManagedObject {
    /* These fields correspond to the JSON structure expected from the server:
        {
            "city": "Beech Grove",
            "coordinates": {
                "latitude": "39.715417",
                "longitude": "-86.095646"
            },
            "name": "William J Ciriello Plumbing Co Inc",
            "overallGrade": "A",
            "postalCode": "46107",
            "state": "Indiana",
            "reviewCount": 309
        }
    */
    // Yikes. There is ugliness accessing Swift String enums from Obj-C :(.
    // E.g., see http://stackoverflow.com/questions/30480338/how-to-make-a-swift-string-enum-available-in-objective-c
    @objc enum FieldName : Int {
        case CITY
        case LATITUDE
        case LONGITUDE
        case NAME
        case GRADE
        case POSTAL_CODE
        case STATE
        case REVIEW_COUNT
        case COORDINATES
        
        var string: String {
            return ServiceProvider.FieldNameToString(self)
        }
    }
    
    class func FieldNameToString(fieldName:FieldName) -> String {
        switch fieldName {
        // These strings *must* match up with names defined in model for this NSManagedObject
        case .CITY:         return "city"
        case .LATITUDE:     return "latitude"
        case .LONGITUDE:    return "longitude"
        case .NAME:         return "name"
        case .GRADE:        return "overallGrade"
        case .POSTAL_CODE:  return "postalCode"
        case .STATE:        return "state"
        case .REVIEW_COUNT: return "reviewCount"
        
        // Don't use this for sorting; this is only in the JSON structure, not in the NSManagedObject
        case .COORDINATES:  return "coordinates"
        }
    }
    
    class func entityName() -> String {
        return "ServiceProvider"
    }

    class func newObject() -> ServiceProvider {
        let serviceProvider = CoreData.sessionNamed(CoreDataSession.name).newObjectWithEntityName(self.entityName()) as! ServiceProvider
        
        CoreData.sessionNamed(CoreDataSession.name).saveContext()

        return serviceProvider
    }
    
    class func newObjectFromDictionary(dict:[String:AnyObject]) -> ServiceProvider? {
        // I'd use a more generic/abstract JSON -> model mapping if I had more model objects, but since I just have one, I'll hand code it.

        if let city = dict[FieldName.CITY.string] as? String,
            let coordinates = dict[FieldName.COORDINATES.string] as? [String:AnyObject],
            let latitude = coordinates[FieldName.LATITUDE.string] as? String,
            let longitude = coordinates[FieldName.LONGITUDE.string] as? String,
            let name = dict[FieldName.NAME.string] as? String,
            let grade = dict[FieldName.GRADE.string] as? String,
            let postalCode = dict[FieldName.POSTAL_CODE.string] as? String,
            let state = dict[FieldName.STATE.string] as? String,
            let reviewCount = dict[FieldName.REVIEW_COUNT.string] as? Int {
            
            let newServiceProvider = self.newObject()
            newServiceProvider.city = city
            newServiceProvider.latitude = Double(latitude)
            newServiceProvider.longitude = Double(longitude)
            newServiceProvider.name = name
            newServiceProvider.overallGrade = grade
            newServiceProvider.postalCode = postalCode
            newServiceProvider.state = state
            newServiceProvider.reviewCount = reviewCount
            
            CoreData.sessionNamed(CoreDataSession.name).saveContext()
            
            return newServiceProvider
        }
        
        return nil
    }
    
    class func fetchAllObjects() -> [ServiceProvider]? {
        var serviceProviders:[ServiceProvider]?
        
        do {
            try serviceProviders = CoreData.sessionNamed(CoreDataSession.name).fetchAllObjectsWithEntityName(self.entityName()) as? [ServiceProvider]
        } catch (let error) {
            Log.error("\(error)")
        }
        
        return serviceProviders
    }
    
    class func fetchRequestForAllObjects(sortedByFieldName fieldName:FieldName) -> NSFetchRequest? {
        var fetchRequest: NSFetchRequest?
        fetchRequest = CoreData.sessionNamed(CoreDataSession.name).fetchRequestWithEntityName(self.entityName(), modifyingFetchRequestWith: nil)
        
        if fetchRequest != nil {
            let sortDescriptor = NSSortDescriptor(key: fieldName.string, ascending: false)
            fetchRequest!.sortDescriptors = [sortDescriptor]
        }
        
        return fetchRequest
    }
    
    func removeObject() {
        CoreData.sessionNamed(CoreDataSession.name).removeObject(self)
        CoreData.sessionNamed(CoreDataSession.name).saveContext()
    }
    
    class func removeAllObjects() {
        var serviceProviders: [ServiceProvider]?
        
        do {
            try serviceProviders = CoreData.sessionNamed(CoreDataSession.name).fetchAllObjectsWithEntityName(self.entityName()) as? [ServiceProvider]
        } catch (let error) {
            Log.error("\(error)")
        }
        
        if serviceProviders != nil {
            for serviceProvider in serviceProviders! {
                serviceProvider.removeObject()
            }
        }
    }
}
