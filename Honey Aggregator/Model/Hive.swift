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
    let hiveName : String	
    let honeyTotal : Float
    var beeBoxes = [BeeBox]()
}
