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
            List(viewModel.houses, id: \.id) { house in
                VStack(alignment: .leading) {
                    Text(house.name ?? "Unnamed")
                        .font(.headline)
                    Text("\(house.address.address1 ?? "No address"), \(house.address.city ?? "No city")")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
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
