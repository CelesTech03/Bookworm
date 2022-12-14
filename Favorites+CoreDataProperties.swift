//
//  Favorites+CoreDataProperties.swift
//  Bookworm
//
//  Created by Celeste Urena on 12/08/22.
//
//

import Foundation
import CoreData

extension Favorites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorites> {
        return NSFetchRequest<Favorites>(entityName: "Favorites")
    }

    @NSManaged public var title: String
    @NSManaged public var author: String

}

extension Favorites : Identifiable {

}
