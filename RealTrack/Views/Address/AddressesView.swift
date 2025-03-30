//
//  AddressesView.swift
//  RealTrack
//
//  Created by Robert Williams on 3/24/25.
//

import SwiftUI
import SwiftData

struct AddressesView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: AddressViewModel
    @State private var isAddingAddress = false
    @State private var addressToDelete: AddressModel? = nil
    @State private var selectedSortOption: SortOption = .city

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
                // MARK: - Sort Picker
                VStack(alignment: .leading, spacing: 5) {
                    Text("Sort by")
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

                // MARK: - List of Addresses
                List {
                    ForEach(sortedAddresses.indices, id: \.self) { index in
                        let address = sortedAddresses[index]
                        NavigationLink(destination: AddressView(address: address)) {
                            VStack(alignment: .leading) {
                                Text(address.address1 ?? "N/A")
                                Text("\(address.city ?? "N/A"), \(address.zip ?? "N/A")")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                addressToDelete = address
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Addresses")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { isAddingAddress = true }) {
                        Label("Add Address", systemImage: "plus")
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchAddresses()
        }
        .sheet(isPresented: $isAddingAddress, onDismiss: {
            viewModel.fetchAddresses()
        }) {
            AddAddressView(viewModel: viewModel)
        }
        .alert(item: $addressToDelete) { address in
            Alert(
                title: Text("Delete Address"),
                message: Text("Are you sure you want to delete this address?"),
                primaryButton: .destructive(Text("Delete"), action: {
                    deleteAddress(address: address)
                }),
                secondaryButton: .cancel()
            )
        }
    }

    // MARK: - Delete Address
    private func deleteAddress(address: AddressModel) {
        do {
            if let originalAddress = viewModel.addresses.first(where: { $0.id == address.id }) {
                modelContext.delete(originalAddress)
                try modelContext.save()
                print("✅ Address deleted successfully!")
                viewModel.fetchAddresses()
            } else {
                print("❌ Address not found in database!")
            }
        } catch {
            print("❌ Error deleting address: \(error)")
        }
    }

    // MARK: - Sorted Addresses
    private var sortedAddresses: [AddressModel] {
        switch selectedSortOption {
        case .city:
            return viewModel.addresses.sorted { ($0.city ?? "") < ($1.city ?? "") }
        case .zipCode:
            return viewModel.addresses.sorted { ($0.zip ?? "") < ($1.zip ?? "") }
        }
    }
}

#Preview {
    AddressesView(modelContext: try! ModelContext(ModelContainer(for: AddressModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))))
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
