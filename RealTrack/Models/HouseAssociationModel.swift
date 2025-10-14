//
//  HouseAssociationModel.swift
//  RealTrack
//
//  Created by Robert Williams on 4/6/25.
//

import SwiftData
import Foundation

@Model
final class HouseAssociationModel {
    @Attribute(.unique) var id: UUID
    var isActive: Bool = true
    var role: String?
    
    var house: HouseModel?
    var person: PersonModel?

    init(house: HouseModel, person: PersonModel, isActive: Bool = true, role: String? = nil) {
        self.id = UUID()
        self.house = house
        self.person = person
        self.isActive = isActive
        self.role = role
    }
}
