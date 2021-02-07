//
//  Hive.swift
//  Honey Aggregator
//
//  Model for Hive
//

import Foundation
import SwiftUI

struct Hive: Hashable, Codable, Identifiable{
    
    let id : Int
    var hiveName : String
    var honeyTotal : Float
    var beeBoxes = [BeeBox]()
    
}
