//
//  AddressView.swift
//  RealTrack
//
//  Created by Robert Williams on 3/22/25.
//

import SwiftUI
import SwiftData
import MapKit

struct AddressView: View {
    let address: AddressModel
    @State private var annotations: [AddressAnnotation] = []
    @State private var isEditing = false
    @State private var isShowingShareSheet = false
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.00902),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )
    // Computed USPS-style address
    var fullAddress: String {
        var lines: [String] = []
        if let line1 = address.address1, !line1.isEmpty {
            lines.append(line1)
        }
        if let line2 = address.address2, !line2.isEmpty {
            lines.append(line2)
        }
        var cityLine = ""
        if let city = address.city, !city.isEmpty {
            cityLine.append(city)
        }
        if let state = address.state, !state.isEmpty {
            if !cityLine.isEmpty { cityLine.append(", ") }
            cityLine.append(state)
        }
        if let zip = address.zip, !zip.isEmpty {
            if !cityLine.isEmpty { cityLine.append(" ") }
            cityLine.append(zip)
        }
        if !cityLine.isEmpty {
            lines.append(cityLine)
        }
        return lines.joined(separator: "\n")
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(fullAddress)
                    .font(.system(.body, design: .monospaced).bold())
                    .multilineTextAlignment(.leading)

                Map(position: $cameraPosition) {
                    ForEach(annotations) { item in
                        Annotation("", coordinate: item.coordinate) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundStyle(.red)
                        }
                    }
                }
                .mapStyle(.standard)
                .frame(height: 250)
                .cornerRadius(10)
                .mapStyle(.standard)
                .frame(height: 250)
                .cornerRadius(10)

                HStack(spacing: 16) {
                    Button(action: openInMaps) {
                        Label("Open in Maps", systemImage: "map")
                    }
                    Button(action: {
                        isShowingShareSheet = true
                    }) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                }
                .font(.headline)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Address")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    isEditing = true
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            EditAddressView(address: address)
        }
        .sheet(isPresented: $isShowingShareSheet) {
            ShareSheet(activityItems: [fullAddress])
        }
        .onAppear {
            geocodeAddress()
        }
    }

    private func openInMaps() {
        let addressString = fullAddress.replacingOccurrences(of: "\n", with: ", ")
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { placemarks, error in
            if let placemark = placemarks?.first,
               let location = placemark.location {
                let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))
                mapItem.name = address.address1
                mapItem.openInMaps(launchOptions: nil)
            } else {
                print("Error geocoding address: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    private func geocodeAddress() {
        let addressString = fullAddress.replacingOccurrences(of: "\n", with: ", ")
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { placemarks, error in
            if let placemark = placemarks?.first,
               let location = placemark.location {
                let coord = location.coordinate
                DispatchQueue.main.async {
                    annotations = [AddressAnnotation(coordinate: coord)]
                    cameraPosition = .region(
                        MKCoordinateRegion(
                            center: coord,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        )
                    )
                }
            } else {
                print("Error geocoding address for map: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

// MARK: - ShareSheet for sharing the address
struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> some UIViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct AddressAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

#Preview {
    let container = try! ModelContainer(
        for: AddressModel.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    let sampleAddress = AddressModel(
        address1: "1 Infinite Loop",
        address2: "Suite 100",
        city: "Cupertino",
        state: "CA",
        zip: "95014"
    )

    container.mainContext.insert(sampleAddress)

    return NavigationStack {
        AddressView(address: sampleAddress)
            .modelContainer(container)
    }
}
