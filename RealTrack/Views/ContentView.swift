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
            
            RolesListView()
                .tabItem {
                    Label("Roles", systemImage: "tag")
                }
        }
    }
}

#Preview {
    let previewManager = CoreDataManager.preview
    return ContentView()
        .environment(\.managedObjectContext, previewManager.context)
}
