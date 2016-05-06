//
//  ServiceProvider+CoreDataProperties.swift
//  MicroAL
//
//  Created by Christopher Prince on 5/5/16.
//  Copyright © 2016 Spastic Muffin, LLC. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ServiceProvider {

    @NSManaged var city: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var name: String?
    @NSManaged var overallGrade: String?
    @NSManaged var postalCode: String?
    @NSManaged var reviewCount: NSNumber?
    @NSManaged var state: String?

}
