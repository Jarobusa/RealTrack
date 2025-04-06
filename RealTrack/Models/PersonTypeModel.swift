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
    @Attribute(.unique) var id: UUID  // ✅ Unique primary key
    var name: String?
    var timestamp: Date

    @Attribute private var _lastModified: Date?
    var lastModified: Date? { _lastModified }
    
    init(id: UUID = UUID(), name: String? = nil, timestamp: Date = Date()) {
        self.id = id
        self.name = name
        self.timestamp = timestamp
    }
    
    func updateLastModified(fromDynamo timestamp: Date) {
        _lastModified = timestamp
    }
}

