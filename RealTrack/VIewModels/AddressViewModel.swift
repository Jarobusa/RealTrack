//
//  AddressViiewModel.swift
//  RealTrack
//
//  Created by Robert Williams on 3/2/25.
//

import SwiftData
import SwiftUI

final class AddressViewModel: ObservableObject {
    @Published var addresses: [AddressModel] = []
    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
      //  fetchAddresses()
    }

    /// Fetch all addresses from SwiftData
    func fetchAddresses() {
        let fetchDescriptor = FetchDescriptor<AddressModel>(sortBy: [SortDescriptor(\.timestamp, order: .reverse)])
        do {
            addresses = try modelContext.fetch(fetchDescriptor)
            print("✅ Fetched addresses: \(addresses.map { $0.address1 ?? "N/A" })")
        } catch {
            print("❌ Fetch error: \(error.localizedDescription)")
            addresses = []
        }
        
        if let storeURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?.appendingPathComponent("default.store") {
            print("📂 SQLite database path: \(storeURL.path)")
        }
    }

    /// Add a new address
    func addAddress(address1: String?, address2: String?, city: String?, state: String?, zip: String?) {
        let newAddress = AddressModel(address1: address1, address2: address2, city: city, state: state, zip: zip, timestamp: Date())

        print("📌 Attempting to insert: \(newAddress)")

        modelContext.insert(newAddress)

        // Save changes
        do {
            try modelContext.save()
            print("✅ Successfully inserted new address")
        } catch {
            print("❌ Failed to save address: \(error)")
        }

        fetchAddresses() // Refresh the list
    }

    /// Delete an address
    func deleteAddress(at offsets: IndexSet) {
           for index in offsets {
               modelContext.delete(addresses[index])
           }

           do {
               try modelContext.save()
               print("✅ Successfully deleted address")
           } catch {
               print("❌ Failed to delete address: \(error)")
           }

           fetchAddresses() // Refresh the list
       }
}
