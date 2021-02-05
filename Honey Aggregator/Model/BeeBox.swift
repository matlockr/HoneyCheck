//
//  BeeBox.swift
//  Honey Aggregator
//
//  Model for BeeBox	
//

import Foundation
import SwiftUI

struct BeeBox: Hashable, Codable, Identifiable{
    
    let id : Int
    let honeyTotal : Float
    var frames = [Frame]()
}
