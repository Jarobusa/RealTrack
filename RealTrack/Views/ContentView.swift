//
//  ContentView.swift
//  RealTrack
//
//  Created by Robert Williams on 3/2/25.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var modelContext

    var body: some View {
        TabView {
            HousesView()
                .tabItem {
                    Label("Houses", systemImage: "house")
                }

            PeopleView()
                .tabItem {
                    Label("People", systemImage: "person")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    let container = NSPersistentContainer(name: "RealTrackModel")
    container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    container.loadPersistentStores { _, error in
        if let error = error {
            fatalError("Preview load error: \(error)")
        }
    }

    return ContentView()
        .environment(\.managedObjectContext, container.viewContext)
}
