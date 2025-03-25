//
//  SeedDatabase.swift
//  RealTrack
//
//  Created by Robert Williams on 3/24/25.
//

import Foundation
import SwiftData

func seedPersonTypesIfNeeded(in context: ModelContext) {
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

func seedAddressTypesIfNeeded(in context: ModelContext) {
    let defaultTypes = ["Home", "Work"]
    let existing = (try? context.fetch(FetchDescriptor<AddressTypeModel>())) ?? []
    let existingNames = Set(existing.compactMap { $0.name })

    for name in defaultTypes where !existingNames.contains(name) {
        context.insert(AddressTypeModel(name: name))
    }

    try? context.save()
}
