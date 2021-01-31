//
//  Frame.swift
//  Honey Aggregator
//
//  Created by user190078 on 1/28/21.
//

import Foundation

struct Frame: Hashable, Codable, Identifiable {
    let id : Int
    let height : Float
    let width : Float
    let honeyAmount : Float
}
