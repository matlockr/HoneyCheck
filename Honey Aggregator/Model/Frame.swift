//
//  Frame.swift
//  Honey Aggregator
//
//  Model for Frame
//

import Foundation

struct Frame: Hashable, Codable, Identifiable {
    
    var id = UUID()
    var height: Float
    var width: Float
    var honeyAmount: Float
    var pictureData: Data?
    
    // Return the picture data
    func getPictureData() -> Data?{
        return pictureData
    }
}
