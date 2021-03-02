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
    var name: String
    var honeyTotal: Float
    var frames = [Frame]()
    
    func getPictureData() -> Data?{
        if !frames.isEmpty{
            return frames.first?.getPictureData()
        }
        return nil
    }
}
