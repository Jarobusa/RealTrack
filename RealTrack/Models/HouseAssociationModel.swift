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
    // Indicates whether the person is active for this specific house.
    var isActive: Bool = true
    // Optionally, you can include a role to indicate the nature of the association (e.g., owner, contractor, etc.)
    var role: String?
    
    // The associated house.
    var house: HouseModel
    // The associated person.
    var person: PersonModel

    init(house: HouseModel, person: PersonModel, isActive: Bool = true, role: String? = nil) {
        self.id = UUID()
        self.house = house
        self.person = person
        self.isActive = isActive
        self.role = role
    }
}
