//
//  Item.swift
//  RealTrack
//
//  Created by Robert Williams on 3/2/25.
//

import Foundation
import SwiftData

@Model
final class AddressModel {
    var id: UUID = UUID()
    var address1: String?
    var address2: String?
    var city: String?
    var state: String?
    var zip: String?
    var timestamp: Date = Date()

    init(id: UUID = UUID(), address1: String? = nil, address2: String? = nil,
         city: String? = nil, state: String? = nil, zip: String? = nil ) {
        self.id = id
        self.address1 = address1
        self.address2 = address2
        self.city = city
        self.state = state
        self.zip = zip
    }
}
