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
    @Attribute(.unique) var id: UUID
    var name: String
    var contactPhone: String?
    var email: String?
    var website: String?
    var address: AddressModel?  // if needed
    var timestamp: Date

    init(id: UUID = UUID(), name: String, contactPhone: String? = nil, email: String? = nil, website: String? = nil, address: AddressModel? = nil, timestamp: Date = .now) {
        self.id = id
        self.name = name
        self.contactPhone = contactPhone
        self.email = email
        self.website = website
        self.address = address
        self.timestamp = timestamp
    }
}
