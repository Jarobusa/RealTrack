//
//  HousesView.swift
//  RealTrack
//
//  Created by Robert Williams on 3/30/25.
//

import SwiftUI
import SwiftData

struct HousessView: View {
    @StateObject private var viewModel: HouseViewModel
    @State private var isPresentingAddHouseView: Bool = false

    init(viewModel: HouseViewModel = HouseViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
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
                AddHouseView()
            }
        }
    }
}

struct HousesView_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = HouseViewModel()
        let mockAddress = AddressModel(address1: "123 Elm St", city: "Springfield")
        mockViewModel.houses = [
            HouseModel(name: "Smith Residence", address: mockAddress),
            HouseModel(name: "Johnson Manor", address: AddressModel(address1: "456 Oak Ave", city: "Greenville")),
            HouseModel(name: "Unnamed", address: AddressModel(address1: nil, city: nil))
        ]
        return HousessView(viewModel: mockViewModel)
    }
}
