//
//  Honey_AggregatorApp.swift
//  Honey Aggregator
//
//  Created by user190078 on 1/28/21.
//

import SwiftUI

@main
struct Honey_AggregatorApp: App {
    
    // Singleton setup for Hives Class object
    let hives = Hives()
    
    // Base for all views in app
    // Also passes the singleton hives object
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(hives)
        }
    }
}
