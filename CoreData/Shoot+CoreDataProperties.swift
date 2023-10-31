//
//  Shoot+CoreDataProperties.swift
//  Swooz
//
//  Created by mora hakim on 22/10/23.
//
//

import Foundation
import CoreData


extension Shoot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Shoot> {
        return NSFetchRequest<Shoot>(entityName: "Shoot")
    }

    @NSManaged public var area: String?
    @NSManaged public var technique: String?
    @NSManaged public var hit: Bool
    @NSManaged public var time: String?
    @NSManaged public var games: Game?

}

extension Shoot : Identifiable {

}
