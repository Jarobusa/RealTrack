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
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {  // ✅ Ensure it's inside a NavigationStack
            Form {
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
