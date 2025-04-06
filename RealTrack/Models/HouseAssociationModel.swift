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
    var timestamp: Date?
    
    // The associated house.
    var house: HouseModel
    // The associated person.
    var person: PersonModel

    @Attribute private var _lastModified: Date?
    var lastModified: Date? { _lastModified }
    
    init(house: HouseModel, person: PersonModel, isActive: Bool = true, role: String? = nil, timestamp: Date = .now) {
        self.id = UUID()
        self.house = house
        self.person = person
        self.isActive = isActive
        self.role = role
        self.timestamp = timestamp
    }
    
    func updateLastModified(fromDynamo timestamp: Date) {
        _lastModified = timestamp
    }
}
