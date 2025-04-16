//
//  RolesListView.swift
//  RealTrack
//
//  Created by Robert Williams on 4/15/25.
//

import SwiftUI
import CoreData

struct RolesListView: View {
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\RoleEntity.name)],
        animation: .default
    )
    private var roles: FetchedResults<RoleEntity>

    var body: some View {
        NavigationStack {
            List {
                ForEach(roles) { role in
                    VStack(alignment: .leading) {
                        Text(role.name ?? "Untitled Role")
                            .font(.headline)

                        if let id = role.id {
                            Text(id.uuidString)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Roles")
        }
    }
}
