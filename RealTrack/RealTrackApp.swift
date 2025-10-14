
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

    let container: ModelContainer = {
        let schema = Schema([
            AddressModel.self,
            HouseModel.self,
            HouseAssociationModel.self,
            OrganizationModel.self,
            PersonModel.self
        ])
        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .automatic
        )
        
        do {
             let container = try ModelContainer(for: schema, configurations: [config])
             
             // --- ADDED CODE TO PRINT DATABASE LOCATION ---
             if let url = container.configurations.first?.url {
                 print("SwiftData SQLite database location: \(url.path)")
             } else {
                 print("Could not determine SwiftData SQLite database location.")
             }
             // --- END ADDED CODE ---
             
             return container
         } catch {
             fatalError("Failed to create ModelContainer: \(error)")
         }
    }()

    init() {
        _ = container.mainContext
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
        }
    }
}
