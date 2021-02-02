//
//  Hive.swift
//  Honey Aggregator
//
//  Created by user190078 on 1/28/21.
//

import Foundation
import SwiftUI

struct Hive: Hashable, Codable, Identifiable{
    
    let id : Int
    let hiveName : String	
    let honeyTotal : Float
    var frames = [Frame]()
}
