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
    var hiveName: String
    var honeyTotal: Float
    //contains metric data for the weight of the honey
    //var honeyTotalKG: Float
    var beeBoxes = [BeeBox]()
    
    func getPictureData() -> Data?{
        if !beeBoxes.isEmpty{
            return beeBoxes.first?.getPictureData()
        }
        
        return nil
    }
}
