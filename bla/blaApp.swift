//
//  blaApp.swift
//  bla
//
//  Created by manfred on 18/11/2024.
//

import SwiftUI

@main
struct blaApp: App {
    @StateObject private var bonjourClient = BonjourClient()
        @State private var showServiceDialog = true
    var body: some Scene {
        WindowGroup {
                   ContentView(bonjourClient: bonjourClient)
                       .onAppear {
                           bonjourClient.startBrowsing()
                       }
                       .sheet(isPresented: $showServiceDialog) {
                           ServiceSelectionDialog(bonjourClient: bonjourClient, isPresented: $showServiceDialog)
                       }
               }
    }
}
