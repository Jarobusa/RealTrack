//
//  RoleEntity+CoreDataProperties.swift
//  RealTrack
//
//  Created by Robert Williams on 4/12/25.
//
//

import Foundation
import CoreData


extension RoleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RoleEntity> {
        return NSFetchRequest<RoleEntity>(entityName: "RoleEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var people: NSSet?

}

// MARK: Generated accessors for people
extension RoleEntity {

    @objc(addPeopleObject:)
    @NSManaged public func addToPeople(_ value: PersonEntity)

    @objc(removePeopleObject:)
    @NSManaged public func removeFromPeople(_ value: PersonEntity)

    @objc(addPeople:)
    @NSManaged public func addToPeople(_ values: NSSet)

    @objc(removePeople:)
    @NSManaged public func removeFromPeople(_ values: NSSet)

}

extension RoleEntity : Identifiable {

}
