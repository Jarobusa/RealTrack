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
    let sharedModelContainer: ModelContainer  // ✅ Declare ModelContainer

    init() {
        let schema = Schema([HouseAddress.self])  // ✅ Define the schema
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            sharedModelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("❌ Could not create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: sharedModelContainer.mainContext)  // ✅ Inject context
                .modelContainer(sharedModelContainer)  // ✅ Ensure ModelContainer is available
        }
    }
}
