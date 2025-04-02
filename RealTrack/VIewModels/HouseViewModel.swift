//
//  HouseViewModel.swift
//  RealTrack
//
//  Created by Robert Williams on 3/30/25.
//

import SwiftData
import SwiftUI

/// ViewModel that manages a collection of HouseModel instances and provides methods to manipulate them.
final class HouseViewModel: ObservableObject {
    /// The list of all houses managed by this view model.
    @Published var houses: [HouseModel] = []

    /// Adds a new house to the list.
    /// - Parameters:
    ///   - name: The name of the house.
    ///   - address: The address associated with the house.
    func addHouse(name: String, address: AddressModel) {
        let newHouse = HouseModel(name: name, address: address)
        houses.append(newHouse)
    }

    /// Deletes the specified house from the list.
    /// - Parameter house: The house to be removed.
    func deleteHouse(_ house: HouseModel) {
        houses.removeAll { $0.id == house.id }
    }

    /// Returns the people associated with the specified house.
    /// - Parameter house: The house whose people should be listed.
    /// - Returns: An array of people in the given house.
    func people(in house: HouseModel) -> [PersonModel] {
        return house.personModel
    }

    /// Returns all houses.
    /// - Returns: An array of all HouseModel instances.
    func getAllHouses() -> [HouseModel] {
        return houses
    }
}
