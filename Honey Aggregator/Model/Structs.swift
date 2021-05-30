//
//  Hive.swift
//  Honey_Aggregator
//
//  Created by Robert Matlock on 3/19/21.
//

import Foundation

// Hive object
struct Hive: Hashable, Codable, Identifiable{
    
    var id = UUID()
    var hiveName: String
    var honeyTotal: Float
    var beeBoxes = [BeeBox]()

}

// BeeBox object
struct BeeBox: Hashable, Codable, Identifiable{
    
    var id = UUID()
    var idx: Int
    var honeyTotal: Float
    var frames = [Frame]()
    
}

// Frame object
struct Frame: Hashable, Codable, Identifiable {
    
    var id = UUID()
    var idx: Int
    var height: Float
    var width: Float
    var honeyTotalSideA: Float
    var honeyTotalSideB: Float
    var dateMade: String
    
}

// Template object
struct Template: Hashable, Codable, Identifiable {
    var id = UUID()
    let name: String
    let height: Float
    let width: Float
}

// Public enum states for the FrameCreator Finite State Machine
enum STATE {
    case SelectHive, SelectBox, SelectFrame, SelectTemplate, CustomTemplate, Picture1Get, Picture2Get, Finalize
}
