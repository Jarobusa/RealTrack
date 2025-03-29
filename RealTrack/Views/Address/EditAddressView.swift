//
//  EditAddressView.swift
//  RealTrack
//
//  Created by Robert Williams on 3/6/25.
//

import SwiftUI
import SwiftData

struct EditAddressView: View {
    @Bindable var address: AddressModel
    @Query private var addressTypes: [AddressTypeModel]  // Fetch available address types
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {  // ✅ Ensure it's inside a NavigationStack
            Form {
                Section(header: Text("Address Type")) {
                    Picker("Address Type", selection: Binding(
                        get: { address.addressType },
                        set: { address.addressType = $0 }
                    )) {
                        ForEach(addressTypes) { type in
                            Text(type.name ?? "Unnamed").tag(type as AddressTypeModel?)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section(header: Text("Address Details")) {
                    TextField("Address 1", text: Binding(
                        get: { address.address1 ?? "" },
                        set: { address.address1 = $0 }
                    ))

                    TextField("Address 2", text: Binding(
                        get: { address.address2 ?? "" },
                        set: { address.address2 = $0 }
                    ))

                    TextField("City", text: Binding(
                        get: { address.city ?? "" },
                        set: { address.city = $0 }
                    ))

                    TextField("State", text: Binding(
                        get: { address.state ?? "" },
                        set: { address.state = $0 }
                    ))

                    TextField("Zip Code", text: Binding(
                        get: { address.zip ?? "" },
                        set: { address.zip = $0 }
                    ))
                }
            }
            .navigationTitle("Edit Address")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {  // ✅ Cancel button on left
                     Button("Cancel") {
                         cancelChanges()
                     }
                     .foregroundColor(.red)  // ✅ Makes it stand out
                }
                
                ToolbarItem(placement: .topBarTrailing) {  // ✅ Save button on right
                    Button("Save") {
                        saveChanges()
                    }
                    .font(.headline)
                }
            }
        }
    }

    /// ✅ Function to save changes and dismiss the view
    private func saveChanges() {
        do {
            try modelContext.save()
            print("✅ Address updated successfully!")
            dismiss()
        } catch {
            print("❌ Error saving address: \(error)")
        }
    }
    
    /// ✅ Function to cancel editing and dismiss the view
    private func cancelChanges() {
        dismiss()  // Simply dismiss without saving
    }
}

#Preview {
    do {
        // ✅ Create a mock in-memory model container for preview
        let modelContainer = try ModelContainer(for: Schema([AddressModel.self]), configurations: [ModelConfiguration(isStoredInMemoryOnly: true)])

        // ✅ Create a sample AddressModel object
        let sampleAddress = AddressModel(
            address1: "123 Main St",
            address2: "Apt 4B",
            city: "New York",
            state: "NY",
            zip: "10001",
            timestamp: Date()
        )

        // ✅ Insert the sample address into the model context
        modelContainer.mainContext.insert(sampleAddress)

        return EditAddressView(address: sampleAddress)
            .modelContainer(modelContainer)  // ✅ Attach model container to preview
    } catch {
        fatalError("Failed to create preview ModelContainer: \(error)")
    }
}
