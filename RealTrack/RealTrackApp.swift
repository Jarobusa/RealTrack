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
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(persistenceController.container)
        }
    }
}

private func seedPersonTypesIfNeeded(in context: ModelContext) {
    let requiredTypes = ["Owner", "Renter", "Handyman"]

    let fetchDescriptor = FetchDescriptor<PersonTypeModel>()
    let existingTypes = (try? context.fetch(fetchDescriptor)) ?? []

    let existingNames = Set(existingTypes.compactMap { $0.name })

    for name in requiredTypes where !existingNames.contains(name) {
        let newType = PersonTypeModel(name: name)
        context.insert(newType)
    }

    do {
        try context.save()
        print("✅ Person types seeded if needed.")
    } catch {
        print("❌ Error seeding person types: \(error)")
    }
}
