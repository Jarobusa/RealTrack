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
    var id: UUID? = UUID()
    var name: String?
    @Relationship(inverse: \AddressModel.house) var address: AddressModel?
    var timestamp: Date = Date()
    
    @Relationship var associations: [HouseAssociationModel]? = []

    init(
        id: UUID? = UUID(),
        name: String? = nil,
        address: AddressModel? = nil,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.address = address
        self.timestamp = timestamp
    }
}
