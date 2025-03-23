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
    @State private var isAddingAddress = false
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
                                deleteAddress(at: index)
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
                    EditButton()
                }
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
    }

    // MARK: - Delete Address
    private func deleteAddress(at index: Int) {
        let addressToDelete = sortedAddresses[index]
        print("Deleting Address ID:", addressToDelete.id)

        do {
            if let originalAddress = viewModel.addresses.first(where: { $0.id == addressToDelete.id }) {
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

    // MARK: - Sort Logic
    private var sortedAddresses: [AddressModel] {
        switch selectedSortOption {
        case .city:
            return viewModel.addresses.sorted { ($0.city ?? "") < ($1.city ?? "") }
        case .zipCode:
            return viewModel.addresses.sorted { ($0.zip ?? "") < ($1.zip ?? "") }
        }
    }
}
