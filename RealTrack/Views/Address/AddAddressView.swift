//
//  AddAddressView.swift
//  RealTrack
//
//  Created by Robert Williams on 3/7/25.
//

import SwiftUI
import SwiftData

struct AddAddressView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    var viewModel: AddressViewModel  // ✅ Pass viewModel to update ContentView
    
    @State private var address1: String = ""
    @State private var address2: String = ""
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var zip: String = ""
    
    @FocusState private var isAddress1Focused: Bool  // ✅ Track focus state
    
    private var isSaveEnabled: Bool {
        !address1.trimmingCharacters(in: .whitespaces).isEmpty &&
        !city.trimmingCharacters(in: .whitespaces).isEmpty &&
        !state.trimmingCharacters(in: .whitespaces).isEmpty &&
        !zip.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Address Details")) {
                    TextField("Address 1", text: $address1, prompt: Text("123 Main St").foregroundColor(.gray))
                        .focused($isAddress1Focused)  // ✅ Focused when view appears
                    TextField("Address 2", text: $address2, prompt: Text("Apt 4B").foregroundColor(.gray))
                    TextField("City", text: $city, prompt: Text("Atlanta").foregroundColor(.gray))
                    TextField("State", text: $state, prompt: Text("GA").foregroundColor(.gray))
                    TextField("Zip Code", text: $zip, prompt: Text("30310").foregroundColor(.gray))
                }
            }
            .navigationTitle("Add Address")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveAddress()
                    }
                    .font(.headline)
                    .disabled(!isSaveEnabled)
                }
            }
            .onAppear {
                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {  // ✅ Slight delay to ensure UI is ready
                     isAddress1Focused = true  // ✅ Automatically focus on address1
                 }
             }
        }
    }
    
    private func saveAddress() {
        let newAddress = AddressModel(
            id: UUID(),  // ✅ Ensure a unique ID is generated
            address1: address1,
            address2: address2.isEmpty ? nil : address2,
            city: city,
            state: state,
            zip: zip,
            timestamp: Date()
        )
        
        modelContext.insert(newAddress)
        
        do {
            try modelContext.save()
            print("✅ Address saved successfully with ID:", newAddress.id)
            viewModel.fetchAddresses()  // ✅ Refresh list
            dismiss()
        } catch {
            print("❌ Error saving address: \(error)")
        }
    }
}
