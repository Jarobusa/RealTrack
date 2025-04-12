//
//  OrganizationEntity+CoreDataProperties.swift
//  RealTrack
//
//  Created by Robert Williams on 4/12/25.
//
//

import Foundation
import CoreData


extension OrganizationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrganizationEntity> {
        return NSFetchRequest<OrganizationEntity>(entityName: "OrganizationEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var workPhone: String?
    @NSManaged public var address: AddressEntity?
    @NSManaged public var notes: NSSet?

}

// MARK: Generated accessors for notes
extension OrganizationEntity {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: NoteEntity)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: NoteEntity)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}

extension OrganizationEntity : Identifiable {

}
