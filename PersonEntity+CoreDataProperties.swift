//
//  PersonEntity+CoreDataProperties.swift
//  RealTrack
//
//  Created by Robert Williams on 4/12/25.
//
//

import Foundation
import CoreData


extension PersonEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonEntity> {
        return NSFetchRequest<PersonEntity>(entityName: "PersonEntity")
    }

    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var mobilePhone: String?
    @NSManaged public var workPhone: String?
    @NSManaged public var homeAddress: AddressEntity?
    @NSManaged public var houseAssociations: NSSet?
    @NSManaged public var notes: NSSet?
    @NSManaged public var workAddress: AddressEntity?

}

// MARK: Generated accessors for houseAssociations
extension PersonEntity {

    @objc(addHouseAssociationsObject:)
    @NSManaged public func addToHouseAssociations(_ value: HouseAssociationEntity)

    @objc(removeHouseAssociationsObject:)
    @NSManaged public func removeFromHouseAssociations(_ value: HouseAssociationEntity)

    @objc(addHouseAssociations:)
    @NSManaged public func addToHouseAssociations(_ values: NSSet)

    @objc(removeHouseAssociations:)
    @NSManaged public func removeFromHouseAssociations(_ values: NSSet)

}

// MARK: Generated accessors for notes
extension PersonEntity {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: NoteEntity)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: NoteEntity)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}

extension PersonEntity : Identifiable {

}
