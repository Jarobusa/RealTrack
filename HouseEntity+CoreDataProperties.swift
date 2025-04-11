//
//  HouseEntity+CoreDataProperties.swift
//  RealTrack
//
//  Created by Robert Williams on 4/11/25.
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
    @NSManaged public var person: HouseAssociationEntity?

}

extension HouseEntity : Identifiable {

}
