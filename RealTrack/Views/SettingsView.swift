//
//  SettingsView.swift
//  RealTrack
//
//  Created by Robert Williams on 4/12/25.
//

import CoreData
import SwiftUI


struct SettingsView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Account")) {
                    if isLoggedIn {
                        Button("Log Out") {
                            isLoggedIn = false
                        }
                    } else {
                        Button("Log In") {
                            isLoggedIn = true
                        }
                    }
                }

                Section(header: Text("Options")) {
                    Toggle("Dark Mode", isOn: .constant(false)) // placeholder
                    Button("Clear Sample Data") {
                        // implement data reset logic here
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
