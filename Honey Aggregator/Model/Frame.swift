//
//  Frame.swift
//  Honey Aggregator
//
//  Model for Frame
//

import Foundation

struct Frame: Hashable, Codable, Identifiable {
    let id : Int
    let height : Float
    let width : Float
    let honeyAmount : Float
}
