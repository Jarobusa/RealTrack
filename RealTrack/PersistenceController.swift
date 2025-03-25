//
//  PersistenceController.swift
//  RealTrack
//
//  Created by Robert Williams on 3/24/25.
//

import SwiftUI
import SwiftData

struct PersistenceController {
    static let shared = PersistenceController()  // Singleton instance

    let container: ModelContainer

    init(inMemory: Bool = false) {
        // Define the schema for your SwiftData models
        let schema = Schema([
            AddressModel.self,
            PersonModel.self,
            PersonTypeModel.self,
            AddressTypeModel.self 
        ])
        // Create a configuration with an option to store in memory (for testing) or on disk
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)
        do {
            container = try ModelContainer(for: schema, configurations: [configuration])
            print("✅ ModelContainer initialized successfully")
        } catch {
            fatalError("❌ Could not create ModelContainer: \(error)")
        }
    }
}
