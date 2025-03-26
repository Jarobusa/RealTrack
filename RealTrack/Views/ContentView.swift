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
            AddressesView(modelContext: modelContext)
                .tabItem {
                    Label("Addresses", systemImage: "house")
                }

            PeopleView()  // ✅ Make sure this struct exists
                .tabItem {
                    Label("Person", systemImage: "person")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [AddressModel.self, PersonModel.self], inMemory: true)
}
