//
//  Hive.swift
//  Honey Aggregator
//
//  Created by user190078 on 1/28/21.
//

import Foundation

struct Hive : Identifiable{
    let id : UUID
    let hiveName : String
    let honeyTotal : Float
    let frames = [Frame]()
}
