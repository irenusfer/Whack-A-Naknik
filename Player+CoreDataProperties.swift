//
//  Player+CoreDataProperties.swift
//  WhackANaknik
//
//  Created by neemdor semel on 14/09/2017.
//  Copyright © 2017 naknik inc. All rights reserved.
//

import Foundation
import CoreData


extension Player {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player")
    }

    @NSManaged public var name: String?
    @NSManaged public var score: Int16
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double

}
