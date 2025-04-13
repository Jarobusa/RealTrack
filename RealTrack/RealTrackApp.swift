//
//  RealTrackApp.swift
//  RealTrack
//
//  Created by Robert Williams on 3/2/25.
//

import SwiftUI
import CoreData

@main
struct RealTrackApp: App {
    let persistentContainer: NSPersistentContainer

    init() {
        persistentContainer = NSPersistentContainer(name: "RealTrackModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data load error: \(error)")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}
