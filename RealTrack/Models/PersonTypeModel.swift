//
//  PersonTypeModel.swift
//  RealTrack
//
//  Created by Robert Williams on 3/22/25.
//

import Foundation
import SwiftData

@Model
final class PersonTypeModel {
    var id: UUID = UUID()
    var name: String?
    var timestamp: Date = Date()

    @Relationship(inverse: \PersonModel.personType) var people: [PersonModel] = []
    
    init(id: UUID = UUID(), name: String? = nil, timestamp: Date = Date()) {
        self.id = id
        self.name = name
        self.timestamp = timestamp
    }
}

