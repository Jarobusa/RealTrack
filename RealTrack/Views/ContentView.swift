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
    @State private var selectedAddress: AddressModel?
    @State private var isEditing = false
    @State private var selectedSortOption: SortOption = .city  // ✅ Track sorting option

    /// Enum for sorting options
    enum SortOption: String, CaseIterable, Identifiable {
        case city = "City"
        case zipCode = "Zip Code"

        var id: String { self.rawValue }
    }

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: AddressViewModel(modelContext: modelContext))
    }

    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 5) {  // ✅ Sort label container
                    Text("Sort by")  // ✅ Added label
                        .font(.headline)
                        .padding(.leading)
                    
                    Picker("Sort by", selection: $selectedSortOption) {
                        ForEach(SortOption.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                }
                .padding(.top)
                List {
                    ForEach(sortedAddresses, id: \.timestamp) { address in
                        Button {
                            selectedAddress = address
                            isEditing = true
                        } label: {
                            VStack(alignment: .leading) {
                                Text(address.address1 ?? "N/A")
                                Text("\(address.city ?? "N/A"), \(address.zip ?? "N/A")")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onDelete(perform: viewModel.deleteAddress)
                }
            }
            .navigationTitle("Addresses")
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
            EditAddressView(address: address)
        }
    }

    /// ✅ Computed property to sort addresses dynamically
    private var sortedAddresses: [AddressModel] {
        switch selectedSortOption {
        case .city:
            return viewModel.addresses.sorted { ($0.city ?? "") < ($1.city ?? "") }
        case .zipCode:
            return viewModel.addresses.sorted { ($0.zip ?? "") < ($1.zip ?? "") }
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
            vm.addresses = [
                AddressModel(address1: "Mock St", city: "Mock City", state: "MC", zip: "99999"),
                AddressModel(address1: "Another St", city: "Alpha Town", state: "AT", zip: "11111"),
                AddressModel(address1: "Main Road", city: "Beta City", state: "BC", zip: "22222")
            ]
            return vm
        }())
}
