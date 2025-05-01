//
//  Entity+CoreDataProperties.swift
//  MapKitExample
//
//  Created by Aslan Korkmaz on 1.05.2025.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var name: String?
    @NSManaged public var note: String?
    @NSManaged public var latitute: Double
    @NSManaged public var longitute: Double
    @NSManaged public var id: UUID?

}

extension Entity : Identifiable {

}
