
//
//  RealTrackApp.swift
//  RealTrack
//
//  Created by Robert Williams on 3/2/25.
//

import SwiftUI
import SwiftData

@main
struct RealTrackApp: App {
    // Shared SwiftData container configured for CloudKit sync
    let container: ModelContainer = {
        // Register your @Model types here
        let schema = Schema([
            AddressModel.self,
            HouseModel.self,
            HouseAssociationModel.self,
            OrganizationModel.self,
            PersonModel.self
            
            // add additional models as needed
        ])
        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .automatic
        )
        // Force-unwrap is okay if your schema/config is valid
        return try! ModelContainer(for: schema, configurations: [config])
    }()

    init() {
        // Seed initial PersonTypes if needed, using SwiftData’s context
        _ = container.mainContext
      //  seedPersonTypesIfNeeded(in: context)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
        }
    }
}
