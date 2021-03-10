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
    var beeBoxes = [BeeBox]()
    
    // Gets the picture data from the first frame in the first box
    func getPictureData() -> Data?{
        if !beeBoxes.isEmpty{
            return beeBoxes.first?.getPictureData()
        }
        return nil
    }
}
