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
        // Define the SwiftData schema by listing all model types used in the app.
        // This schema is passed into the configuration to inform the ModelContainer
        // of the structure of your data models.
        let schema = Schema([
            AddressModel.self,
            HouseModel.self,
            HouseAssociationModel.self,
            PersonModel.self,
            PersonTypeModel.self,
            OrganizationModel.self
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
