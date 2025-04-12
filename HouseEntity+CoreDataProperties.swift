//
//  HouseEntity+CoreDataProperties.swift
//  RealTrack
//
//  Created by Robert Williams on 4/12/25.
//
//

import Foundation
import CoreData


extension HouseEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HouseEntity> {
        return NSFetchRequest<HouseEntity>(entityName: "HouseEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var address: AddressEntity?
    @NSManaged public var notes: NSSet?
    @NSManaged public var personAssociations: NSSet?

}

// MARK: Generated accessors for notes
extension HouseEntity {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: NoteEntity)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: NoteEntity)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}

// MARK: Generated accessors for personAssociations
extension HouseEntity {

    @objc(addPersonAssociationsObject:)
    @NSManaged public func addToPersonAssociations(_ value: HouseAssociationEntity)

    @objc(removePersonAssociationsObject:)
    @NSManaged public func removeFromPersonAssociations(_ value: HouseAssociationEntity)

    @objc(addPersonAssociations:)
    @NSManaged public func addToPersonAssociations(_ values: NSSet)

    @objc(removePersonAssociations:)
    @NSManaged public func removeFromPersonAssociations(_ values: NSSet)

}

extension HouseEntity : Identifiable {

}
