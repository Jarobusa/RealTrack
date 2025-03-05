//
//  ContentView.swift
//  RealTrack
//
//  Created by Robert Williams on 3/2/25.
//

import Foundation
import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: AddressViewModel

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: AddressViewModel(modelContext: modelContext))
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.addresses, id: \.timestamp) { address in
                    NavigationLink {
                        Text("Address at \(address.timestamp.formatted())")
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
    }

    private func addAddress() {
        viewModel.addAddress(address1: "123 Main St", address2: nil, city: "New York", state: "NY", zip: "10001")
    }
}

#Preview {
    do {
        let previewContainer = try ModelContainer(for: Schema([HouseAddress.self]), configurations: [ModelConfiguration(isStoredInMemoryOnly: true)])
        return ContentView(modelContext: previewContainer.mainContext)
    } catch {
        fatalError("Failed to create preview ModelContainer: \(error)")
    }
}
