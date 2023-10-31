//
//  Game+CoreDataProperties.swift
//  Swooz
//
//  Created by mora hakim on 22/10/23.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var duration: Int16
    @NSManaged public var shoots: NSSet?

}

// MARK: Generated accessors for shoots
extension Game {

    @objc(addShootsObject:)
    @NSManaged public func addToShoots(_ value: Shoot)

    @objc(removeShootsObject:)
    @NSManaged public func removeFromShoots(_ value: Shoot)

    @objc(addShoots:)
    @NSManaged public func addToShoots(_ values: NSSet)

    @objc(removeShoots:)
    @NSManaged public func removeFromShoots(_ values: NSSet)

}

extension Game : Identifiable {

}
