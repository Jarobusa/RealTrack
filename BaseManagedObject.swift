//
//  BaseManagedObject.swift
//  RealTrack
//
//  Created by Robert Williams on 4/11/25.
//

import CoreData

public class BaseManagedObject: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var deletedAt: Date?
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        let now = Date()
        self.id = UUID()
        self.createdAt = now
        self.updatedAt = now
    }

    public override func willSave() {
        super.willSave()

        if hasChanges {
            self.updatedAt = Date()
        }
    }
}
