//
//  ContentView.swift
//  RealTrack
//
//  Created by Robert Williams on 3/2/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: AddressViewModel
    @State private var selectedAddress: AddressModel?  // ✅ Updated type
    @State private var isEditing = false

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: AddressViewModel(modelContext: modelContext))
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.addresses, id: \.timestamp) { address in
                    Button {
                        selectedAddress = address
                        isEditing = true
                    } label: {
                        VStack(alignment: .leading) {
                            Text(address.address1 ?? "N/A")
                            Text(address.city ?? "N/A").font(.subheadline).foregroundColor(.gray)
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteAddress)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addAddress) {
                        Label("Add Address", systemImage: "plus")
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchAddresses()
        }
        .sheet(item: $selectedAddress) { address in
            EditAddressView(address: address)  // ✅ Open Edit View
        }
    }

    private func addAddress() {
        viewModel.addAddress(address1: "123 Main St", address2: nil, city: "New York", state: "NY", zip: "10001")
    }
}

#Preview {
    ContentView(modelContext: try! ModelContext(ModelContainer(for: AddressModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))))
        .environmentObject({
            let vm = AddressViewModel(modelContext: try! ModelContext(ModelContainer(for: AddressModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))))
            vm.addresses = [AddressModel(address1: "Mock St", city: "Mock City", state: "MC", zip: "99999")]
            return vm
        }())
}


