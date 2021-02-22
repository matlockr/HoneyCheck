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
    //contains metric data for height
    var heightMet: Float
    var width: Float
    //contains metric data for width
    var widthMet: Float
    var honeyAmount: Float
    //contains metric data for the weight of the honey
    var honeyAmountMet: Float
    var pictureData: Data?
    
    func getPictureData() -> Data?{
        return pictureData
    }
}
