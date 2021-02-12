//
//  ModelData.swift
//  Honey Aggregator
//
//  Model Data decoder
//

import Foundation

class Hives: ObservableObject{

    let fileName = "hiveData.json"
    let dir: URL
    @Published var hiveList = [Hive]()
    
    init(){
        
        // Get directory path for where to save files
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        dir = paths[0]
        let fileURL = dir.appendingPathComponent(fileName)
        
        // Test read to see if file is empty, if so then add a base to json file
        do {
            let fileTxt = try String(contentsOf: fileURL, encoding: .utf8)
            if fileTxt == ""{
                try "[]".write(to: fileURL, atomically: false, encoding: .utf8)
            }
        } catch is CocoaError{ // This error is for when there is no existing file
            // Write to the file for the first time and give it the base JSON structure
            do {
                try "[]".write(to: fileURL, atomically: false, encoding: .utf8)
            } catch {
                fatalError("Couldn't write to \(fileName) \(error)\n\n\(type(of: error))\n\n")
            }
        } catch { // Any other error should stop the app
            fatalError("Couldn't read \(fileName) \(error)\n\n\(type(of: error))\n\n")
        }
        
        // Decode file information and set it to hiveList
        do {
            let decoder = JSONDecoder()
            hiveList = try decoder.decode([Hive].self, from: try Data(contentsOf: fileURL))
        } catch {
            fatalError("Couldn't parse \(fileName) as [Hive] :\n\(error)")
        }
        
    }
    
    // save function encodes the hive information and saves it to
    // a JSON file. Currently has no way to overwrite existing hives.
    func save(){
        do {
            // Setup the encoder
            let encoder = JSONEncoder()
            
            // Attempt to encode the hivelist data
            let data = try encoder.encode(hiveList)
            
            // Get the correct directory path to save the hivelist data
            let fileURL = dir.appendingPathComponent(fileName)
            
            // Attempt to write to file
            try data.write(to: fileURL)
            
        } catch {
            fatalError("Couldn't save data to \(fileName)")
        }
    }
}
