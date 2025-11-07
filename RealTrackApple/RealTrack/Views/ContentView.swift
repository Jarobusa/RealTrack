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

    var body: some View {
        TabView {
            PeopleView()
                .tabItem {
                    Label("Person", systemImage: "person")
                }

            HousessView(modelContext: modelContext)
                .tabItem {
                    Label("Houses", systemImage: "house")
                }
            
            AddressesView(modelContext: modelContext)
                .tabItem {
                    Label("Addresses", systemImage: "building.columns")
                }

        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [AddressModel.self, PersonModel.self], inMemory: true)
}
