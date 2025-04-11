//
//  PersonEntity+CoreDataProperties.swift
//  RealTrack
//
//  Created by Robert Williams on 4/11/25.
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
    @NSManaged public var workAddress: AddressEntity?
    @NSManaged public var house: HouseAssociationEntity?

}

extension PersonEntity : Identifiable {

}
