//
//  AddressEntity+CoreDataProperties.swift
//  RealTrack
//
//  Created by Robert Williams on 4/12/25.
//
//

import Foundation
import CoreData


extension AddressEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AddressEntity> {
        return NSFetchRequest<AddressEntity>(entityName: "AddressEntity")
    }

    @NSManaged public var address1: String?
    @NSManaged public var address2: String?
    @NSManaged public var city: String?
    @NSManaged public var state: String?
    @NSManaged public var zipCode: String?
    @NSManaged public var houses: NSSet?
    @NSManaged public var organizations: NSSet?
    @NSManaged public var residentsHome: NSSet?
    @NSManaged public var residentsWork: NSSet?

}

// MARK: Generated accessors for houses
extension AddressEntity {

    @objc(addHousesObject:)
    @NSManaged public func addToHouses(_ value: HouseEntity)

    @objc(removeHousesObject:)
    @NSManaged public func removeFromHouses(_ value: HouseEntity)

    @objc(addHouses:)
    @NSManaged public func addToHouses(_ values: NSSet)

    @objc(removeHouses:)
    @NSManaged public func removeFromHouses(_ values: NSSet)

}

// MARK: Generated accessors for organizations
extension AddressEntity {

    @objc(addOrganizationsObject:)
    @NSManaged public func addToOrganizations(_ value: OrganizationEntity)

    @objc(removeOrganizationsObject:)
    @NSManaged public func removeFromOrganizations(_ value: OrganizationEntity)

    @objc(addOrganizations:)
    @NSManaged public func addToOrganizations(_ values: NSSet)

    @objc(removeOrganizations:)
    @NSManaged public func removeFromOrganizations(_ values: NSSet)

}

// MARK: Generated accessors for residentsHome
extension AddressEntity {

    @objc(addResidentsHomeObject:)
    @NSManaged public func addToResidentsHome(_ value: PersonEntity)

    @objc(removeResidentsHomeObject:)
    @NSManaged public func removeFromResidentsHome(_ value: PersonEntity)

    @objc(addResidentsHome:)
    @NSManaged public func addToResidentsHome(_ values: NSSet)

    @objc(removeResidentsHome:)
    @NSManaged public func removeFromResidentsHome(_ values: NSSet)

}

// MARK: Generated accessors for residentsWork
extension AddressEntity {

    @objc(addResidentsWorkObject:)
    @NSManaged public func addToResidentsWork(_ value: PersonEntity)

    @objc(removeResidentsWorkObject:)
    @NSManaged public func removeFromResidentsWork(_ value: PersonEntity)

    @objc(addResidentsWork:)
    @NSManaged public func addToResidentsWork(_ values: NSSet)

    @objc(removeResidentsWork:)
    @NSManaged public func removeFromResidentsWork(_ values: NSSet)

}

extension AddressEntity : Identifiable {

}
