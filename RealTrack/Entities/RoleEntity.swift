//
//  RoleEntity.swift
//  RealTrack
//
//  Created by Robert Williams on 4/15/25.
//

import Foundation
import CoreData

extension RoleEntity {
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.id = UUID()
    }
}
