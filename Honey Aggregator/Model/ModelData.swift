//
//  ModelData.swift
//  Honey Aggregator
//
//  Model Data decoder
//

import Foundation

class Hives: ObservableObject{

    let mainJSONFileName = "hiveData.json"
    @Published var hiveList = [Hive]()
    
    init(){
        hiveList = load(mainJSONFileName)
    }

    func load<T: Decodable>(_ filename: String) -> T {
        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }

    // save function encodes the hive information and saves it to
    // a JSON file. Currently has no way to overwrite existing hives.
    func save(){
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(hiveList)
            if let file = FileHandle(forWritingAtPath:mainJSONFileName) {
                file.write(data)
            }
        } catch {
            fatalError("Couldn't save data to \(mainJSONFileName)")
        }
    }
}
