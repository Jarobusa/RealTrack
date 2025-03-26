//
//  AddressTypeModel.swift
//  RealTrack
//
//  Created by Robert Williams on 3/24/25.
//

import Foundation
import SwiftData

@Model
final class AddressTypeModel {
    @Attribute(.unique) var id: UUID
    var name: String?
    var timestamp: Date

    init(id: UUID = UUID(), name: String? = nil, timestamp: Date = Date()) {
        self.id = id
        self.name = name
        self.timestamp = timestamp
    }
}
