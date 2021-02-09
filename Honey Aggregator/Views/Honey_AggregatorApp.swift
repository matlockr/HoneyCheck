//
//  Honey_AggregatorApp.swift
//  Honey Aggregator
//
//  Created by user190078 on 1/28/21.
//

import SwiftUI

@main
struct Honey_AggregatorApp: App {
    
    let hives = Hives()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(hives)
        }
    }
}
