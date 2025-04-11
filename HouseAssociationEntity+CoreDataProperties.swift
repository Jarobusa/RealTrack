//
//  HouseAssociationEntity+CoreDataProperties.swift
//  RealTrack
//
//  Created by Robert Williams on 4/11/25.
//
//

import Foundation
import CoreData


extension HouseAssociationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HouseAssociationEntity> {
        return NSFetchRequest<HouseAssociationEntity>(entityName: "HouseAssociationEntity")
    }

    @NSManaged public var role: String?
    @NSManaged public var person: PersonEntity?
    @NSManaged public var house: HouseEntity?

}

extension HouseAssociationEntity : Identifiable {

}
