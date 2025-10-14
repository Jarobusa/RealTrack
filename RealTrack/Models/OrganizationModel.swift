//
//  OrganizationModel.swift
//  RealTrack
//
//  Created by Robert Williams on 3/25/25.
//

import Foundation
import SwiftData

@Model
final class OrganizationModel {
    var id: UUID? = UUID()
    var name: String? = nil
    var contactPhone: String?
    var email: String?
    var website: String?
    @Relationship(inverse: \AddressModel.organization) var address: AddressModel?
    var timestamp: Date = Date()

    init(id: UUID? = UUID(), name: String? = nil, contactPhone: String? = nil, email: String? = nil, website: String? = nil, address: AddressModel? = nil, timestamp: Date = .now) {
        self.id = id
        self.name = name
        self.contactPhone = contactPhone
        self.email = email
        self.website = website
        self.address = address
        self.timestamp = timestamp
    }
}
