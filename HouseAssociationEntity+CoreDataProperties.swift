//
//  HouseAssociationEntity+CoreDataProperties.swift
//  RealTrack
//
//  Created by Robert Williams on 4/12/25.
//
//

import Foundation
import CoreData


extension HouseAssociationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HouseAssociationEntity> {
        return NSFetchRequest<HouseAssociationEntity>(entityName: "HouseAssociationEntity")
    }

    @NSManaged public var role: String?
    @NSManaged public var house: HouseEntity?
    @NSManaged public var person: PersonEntity?

}

extension HouseAssociationEntity : Identifiable {

}
