//
//  Item.swift
//  RealTrack
//
//  Created by Robert Williams on 3/2/25.
//

import Foundation
import SwiftData

@Model
final class HouseAddress {
    var address1: String?  // ✅ Fixed typo (addres1 → address1)
    var address2: String?
    var city: String?
    var state: String?
    var zip: String?
    var timestamp: Date

    init(address1: String? = nil, address2: String? = nil, city: String? = nil,
         state: String? = nil, zip: String? = nil, timestamp: Date = Date()) {
        self.address1 = address1
        self.address2 = address2
        self.city = city
        self.state = state
        self.zip = zip
        self.timestamp = timestamp
    }
}
