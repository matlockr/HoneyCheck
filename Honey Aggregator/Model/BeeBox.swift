//
//  BeeBox.swift
//  Honey Aggregator
//
//  Model for BeeBox	
//

import Foundation
import SwiftUI

struct BeeBox: Hashable, Codable, Identifiable{
    
    var id = UUID()
    var honeyTotal: Float
    var frames = [Frame]()
}
