//
//  HouseAssociationModel.swift
//  RealTrack
//
//  Created by Robert Williams on 4/6/25.
//

import Foundation
import SwiftData

@Model
final class HouseAssociationModel {
    var id: UUID? = UUID()
    var isActive: Bool = true
    var role: String?
    
    @Relationship(inverse: \HouseModel.associations) var house: HouseModel?
    @Relationship(inverse: \PersonModel.houseAssociations) var person: PersonModel?

    init(house: HouseModel? = nil, person: PersonModel? = nil, isActive: Bool = true, role: String? = nil) {
        self.id = UUID()
        self.house = house
        self.person = person
        self.isActive = isActive
        self.role = role
    }
}
