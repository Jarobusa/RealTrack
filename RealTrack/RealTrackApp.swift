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
    let persistenceController = PersistenceController.shared

    init() {
        let context = persistenceController.container.mainContext
        seedPersonTypesIfNeeded(in: context)
        seedAddressTypesIfNeeded(in: context)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(persistenceController.container)
        }
    }
}

