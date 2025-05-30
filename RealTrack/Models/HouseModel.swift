//
//  HouseModel.swift
//  RealTrack
//
//  Created by Robert Williams on 3/30/25.
//

import Foundation
import SwiftData

@Model
final class HouseModel {
    @Attribute(.unique) var id: UUID
    var name: String?
    var address: AddressModel
    var timestamp: Date
    
    // Replace direct PersonModel relationship with HouseAssociation
    @Relationship(
        deleteRule: .cascade,
        inverse: \HouseAssociationModel.house
    )
    
    var associations: [HouseAssociationModel] = []

    init(
        id: UUID = UUID(),
        name: String,
        address: AddressModel,
        timestamp: Date = .now
    ) {
        self.id = id
        self.name = name
        self.address = address
        self.timestamp = timestamp
    }
}
