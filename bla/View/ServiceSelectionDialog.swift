//
//  ServiceSelectionDialog.swift
//  bla
//
//  Created by manfred on 26/11/2024.
//


import SwiftUI

struct ServiceSelectionDialog: View {
    @ObservedObject var bonjourClient: BonjourClient
    @Binding var isPresented: Bool // Controls dialog visibility

    var body: some View {
        NavigationView {
            List {
                ForEach(bonjourClient.services, id: \.name) { service in
                    HStack {
                        Text(service.name)
                        Spacer()
                        Button("Connect") {
                            bonjourClient.connectToService(service)
                            isPresented = false // Close the dialog after selection
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .navigationTitle("Available Services")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
}
