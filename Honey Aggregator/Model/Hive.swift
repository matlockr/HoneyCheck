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
    //determines the displayed units
    var unit : Int
    var hiveName: String
    var honeyTotal: Float
    //contains metric data for the weight of the honey
    var honeyTotalKG: Float
    var beeBoxes = [BeeBox]()
    
    func getPictureData() -> Data?{
        if !beeBoxes.isEmpty{
            return beeBoxes.first?.getPictureData()
        }
        
        return nil
    }
    
    //this sets the unit type for the
    mutating func setUnitType(type: Int){
        self.unit = type
    }
    //this displays the unit type
    func dispUnitType() -> Int{
        return self.unit
    }
}
