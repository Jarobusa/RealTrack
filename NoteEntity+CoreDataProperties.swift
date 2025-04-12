//
//  NoteEntity+CoreDataProperties.swift
//  RealTrack
//
//  Created by Robert Williams on 4/12/25.
//
//

import Foundation
import CoreData


extension NoteEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteEntity> {
        return NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var value: String?
    @NSManaged public var houses: HouseEntity?
    @NSManaged public var organizations: OrganizationEntity?
    @NSManaged public var people: PersonEntity?

}

extension NoteEntity : Identifiable {

}
