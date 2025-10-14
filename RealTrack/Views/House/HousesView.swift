//
//  HousesView.swift
//  RealTrack
//
//  Created by Robert Williams on 3/30/25.
//

import SwiftUI
import SwiftData

struct HousessView: View {
    let modelContext: ModelContext
    @StateObject private var viewModel: HouseViewModel
    @Query(sort: \HouseModel.timestamp, order: .reverse) var houses: [HouseModel]
    @State private var isPresentingAddHouseView: Bool = false

    init(modelContext: ModelContext, viewModel: HouseViewModel? = nil) {
        self.modelContext = modelContext
        if let viewModel = viewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        } else {
            _viewModel = StateObject(wrappedValue: HouseViewModel(context: modelContext))
        }
    }

    var body: some View {
        NavigationStack {
            List(houses, id: \.id) { house in
                NavigationLink(destination: HouseView(modelContext: modelContext, house: house)) {
                    VStack(alignment: .leading) {
                        Text(house.name ?? "Unnamed")
                            .font(.headline)
                        if let addr = house.address {
                            Text("\(addr.address1 ?? "No address"), \(addr.city ?? "No city"), \(addr.state ?? "No state")")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        } else {
                            Text("No address")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .swipeActions {
                    Button(role: .destructive) {
                        deleteHouse(house)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .navigationTitle("Houses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresentingAddHouseView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingAddHouseView) {
                AddHouseView(modelContext: modelContext)
            }
        }
    }
    
    private func deleteHouse(_ house: HouseModel) {
        modelContext.delete(house)
        do {
            try modelContext.save()
        } catch {
            print("Error saving deletion: \(error)")
        }
    }
}

struct HousesView_Previews: PreviewProvider {
    static var previews: some View {
        let container = try! ModelContainer(for: HouseModel.self, AddressModel.self, PersonModel.self)
        let modelContext = container.mainContext
        let mockViewModel = HouseViewModel(context: modelContext)
        let mockAddress = AddressModel(address1: "123 Elm St", city: "Springfield")
        mockViewModel.houses = [
            HouseModel(name: "Smith Residence", address: mockAddress),
            HouseModel(name: "Johnson Manor", address: AddressModel(address1: "456 Oak Ave", city: "Greenville")),
            HouseModel(name: "Unnamed", address: AddressModel(address1: nil, city: nil))
        ]
        return HousessView(modelContext: modelContext, viewModel: mockViewModel)
    }
}

