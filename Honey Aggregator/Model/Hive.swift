//
//  Hive.swift
//  Honey Aggregator
//
//  Model for Hive
//

import Foundation
import SwiftUI

struct Hive: Hashable, Codable, Identifiable{
    
    var id = UUID()
    var hiveName : String
    var honeyTotal : Float
    var beeBoxes = [BeeBox]()
    
}
