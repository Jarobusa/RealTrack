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
    let sharedModelContainer: ModelContainer

    init() {
        do {
            let schema = Schema([HouseAddress.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            sharedModelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            print("✅ ModelContainer initialized successfully")
        } catch {
            fatalError("❌ Could not create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: sharedModelContainer.mainContext)
                .modelContainer(sharedModelContainer)
        }
    }
}
