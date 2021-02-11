//
//  ModelData.swift
//  Honey Aggregator
//
//  Model Data decoder
//

import Foundation

class Hives: ObservableObject{

    let mainJSONFileName = "hiveData.json"
    let dir: URL
    @Published var hiveList = [Hive]()
    
    init(){
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        dir = paths[0]
        let fileURL = dir.appendingPathComponent(mainJSONFileName)
        
        //Test if file exists
        do {
            
        }
        
        // Test read to see if file is empty, if so then add a base to json file
        do {
            let fileTxt = try String(contentsOf: fileURL, encoding: .utf8)
            if fileTxt == ""{
                let baseJSON = "[]"
                try baseJSON.write(to: fileURL, atomically: false, encoding: .utf8)
            }
        } catch is CocoaError{
            do {
                try "[]".write(to: fileURL, atomically: false, encoding: .utf8)
            } catch {
                fatalError("Couldn't write to \(mainJSONFileName) \(error)\n\n\(type(of: error))\n\n")
            }
        } catch {
            fatalError("Couldn't read \(mainJSONFileName) \(error)\n\n\(type(of: error))\n\n")
        }
        
        // Decode file information and set it to hiveList
        do {
            let decoder = JSONDecoder()
            hiveList = try decoder.decode([Hive].self, from: try Data(contentsOf: fileURL))
        } catch {
            fatalError("Couldn't parse \(mainJSONFileName) as [Hive] :\n\(error)")
        }
        
    }
    
    // save function encodes the hive information and saves it to
    // a JSON file. Currently has no way to overwrite existing hives.
    func save(){
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(hiveList)
            
            let fileURL = dir.appendingPathComponent(mainJSONFileName)
            
            // write
            do {
                try data.write(to: fileURL)
            } catch {
                //error
            }
            
            
        } catch {
            fatalError("Couldn't save data to \(mainJSONFileName)")
        }
    }
}
