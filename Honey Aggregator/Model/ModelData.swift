//
//  ModelData.swift
//  Honey_Aggregator
//
//  Created by Robert Matlock on 3/19/21.
//

import Foundation

class Hives: ObservableObject{
    
    // File name of where the hive data is saved
    let fileName = "hivesdata.json"
    let dir: URL
    
    // Setup for the singleton object for the hive list
    @Published var hiveList = [Hive]()
    
    // Setup for the readout information for the main page
    @Published var readOut: String = ""
    
    @Published var menuArray:
        [String] = []
    // Setup for unit type
    var isMetric: Bool = false
    
    // Reset file for testing purposes
    let fileReset = false
        
    // List of Template types for template selection
    let templates = [
        Template(name: "Langstroff Deep", height: 9.5625, width: 19.0),
        Template(name: "Langstroff Medium", height: 6.625, width: 19.0),
        Template(name: "Langstroff Shallow", height: 5.75, width: 19.0)
    ]
    
    init(){
        
        // Get directory path for where to save files
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        dir = paths[0]
        
        // Use the fileName variable to position file reading in FileManager
        let fileURL = dir.appendingPathComponent(fileName)
        
        // Test read to see if file is empty, if so then add a base to json file
        do {
            // Get the text from the file
            let fileTxt = try String(contentsOf: fileURL, encoding: .utf8)
            
            // Build base to file if empty or looking to reset file
            if fileTxt == ""{
                try "[]".write(to: fileURL, atomically: false, encoding: .utf8)
            } else if (fileReset){
                try "[]".write(to: fileURL, atomically: false, encoding: .utf8)
            }
            
        } catch is CocoaError{ // This error is for when there is no existing file
            // Write to the file for the first time and give it the base JSON structure
            do {
                try "[]".write(to: fileURL, atomically: false, encoding: .utf8)
            } catch {
                fatalError("Couldn't write to \(fileName) \(error)\n\n\(type(of: error))\n\n")
            }
        } catch {
            // Any other error should stop the app
            fatalError("Couldn't read \(fileName) \(error)\n\n\(type(of: error))\n\n")
        }
        
        // Decode file information and build the list of hives
        do {
            let decoder = JSONDecoder()
            hiveList = try decoder.decode([Hive].self, from: try Data(contentsOf: fileURL))
            
        } catch {
            fatalError("Couldn't parse \(fileName) as [Hive] :\n\(error)")
        }
        
    }
    
    // Save function encodes the hive information and saves it to a JSON file.
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
    
    // Create a string based on the information stored in the hive to show
    // on the main page for debug purposes.
    func getReadOut() -> String{
        var readOutString = ""
        
        for i in 0..<hiveList.count{
            readOutString += "Hive: \(hiveList[i].hiveName)\n"
            for j in 0..<hiveList[i].beeBoxes.count{
                readOutString += "\tBox: \(j)\n"
                for k in 0..<hiveList[i].beeBoxes[j].frames.count{
                    readOutString += "\t\tFrame: \(k) \n"
                    
                    if isMetric{
                        readOutString += "\t\t\tHoney Total: \(String(format: "%.2f", hiveList[i].beeBoxes[j].frames[k].honeyTotal / 2.20)) kg\n"
                    } else {
                        readOutString += "\t\t\tHoney Total: \(String(format: "%.2f", hiveList[i].beeBoxes[j].frames[k].honeyTotal)) lbs\n"
                    }
                }
            }
            readOutString += "\n"
        }
        
        return readOutString
    }
    
    //Modified version of the readout function to add all the hives to an array.
    func menuReadArray() -> [String] {
        var readOutArray: [String] = []
        
        for i in 0..<hiveList.count{
            readOutArray.append("\(hiveList[i].hiveName)")
        }
        return readOutArray
    }
    //Modified version of the readout function that allows for finding a specific element in the hive list and displaying just that one set of data as a string.
    func menuSelect(index: Int) -> String {
        var readOutString = ""
        var tempIndex: Int?
        for i in 0..<hiveList.count{
            if i == index {
                tempIndex = i
            }
        }
        if tempIndex != nil {
            readOutString += "Hive: \(hiveList[tempIndex!].hiveName)\n"
            for j in 0..<hiveList[tempIndex!].beeBoxes.count{
                readOutString += "\tBox: \(j)\n"
                for k in 0..<hiveList[tempIndex!].beeBoxes[j].frames.count{
                    readOutString += "\t\tFrame: \(k) \n"
                
                    if isMetric{
                        readOutString += "\t\t\tHoney Total: \(String(format: "%.2f", hiveList[tempIndex!].beeBoxes[j].frames[k].honeyTotal / 2.20)) kg\n"
                    } else {
                        readOutString += "\t\t\tHoney Total: \(String(format: "%.2f", hiveList[tempIndex!].beeBoxes[j].frames[k].honeyTotal)) lbs\n"
                    }
                }
            }
        }
        return readOutString
    }
    // Add a BeeBox to a hive using the hive's UUID
    func addBox(hiveid: UUID){
        for i in 0..<hiveList.count {
            if hiveid == hiveList[i].id{
                let newBeeBox = BeeBox(idx: hiveList[i].beeBoxes.count, honeyTotal: 0.0, frames: [])
                hiveList[i].beeBoxes.append(newBeeBox)
                
                readOut = getReadOut()
                return
            }
        }
    }
    
    // Get the BeeBoxes from a hive using the hive's UUID
    func getBoxes(hiveid: UUID) -> [BeeBox]{
        for i in 0..<hiveList.count {
            if hiveid == hiveList[i].id{
                return hiveList[i].beeBoxes
            }
        }
        return []
    }
    
    // Get the Frames from a BeeBox using a BeeBox's UUID
    func getFrames(boxid: UUID) -> [Frame]{
        for i in 0..<hiveList.count {
            for j in 0..<hiveList[i].beeBoxes.count{
                if boxid == hiveList[i].beeBoxes[j].id{
                    return hiveList[i].beeBoxes[j].frames
                }
            }
        }
        return []
    }
    
    // Delete a hive
    func deleteHive(hiveid: UUID){
        for i in 0..<hiveList.count{
            if hiveid == hiveList[i].id{
                hiveList.remove(at: i)
                
                readOut = getReadOut()
                menuArray = menuReadArray()
                return
            }
        }
    }
    
    // Delete a box
    func deleteBox(boxid: UUID){
        for i in 0..<hiveList.count{
            for j in 0..<hiveList[i].beeBoxes.count{
                if boxid == hiveList[i].beeBoxes[j].id{
                    for k in j..<hiveList[i].beeBoxes.count{
                        hiveList[i].beeBoxes[k].idx -= 1
                    }
                    hiveList[i].beeBoxes.remove(at: j)
                    
                    readOut = getReadOut()
                    return
                }
            }
        }
    }
    
    // Delete a frame
    func deleteFrame(frameid: UUID){
        for i in 0..<hiveList.count{
            for j in 0..<hiveList[i].beeBoxes.count{
                for k in 0..<hiveList[i].beeBoxes[j].frames.count{
                    for l in k..<hiveList[i].beeBoxes[j].frames.count{
                        hiveList[i].beeBoxes[j].frames[l].idx -= 1
                    }
                    if frameid == hiveList[i].beeBoxes[j].frames[k].id{
                        hiveList[i].beeBoxes[j].frames.remove(at: k)
                        
                        readOut = getReadOut()
                        return
                    }
                }
            }
        }

    }
    //This removes all hiveList data Test for whether this is only current data
    func reset(){
        hiveList.removeAll()
        save()
        readOut = getReadOut()
    }
    
    // Add a hive to the hives list
    func addHive(name: String){
        if name != ""{
            let newHive = Hive(hiveName: name, honeyTotal: 0.0, beeBoxes: [])
            hiveList.append(newHive)
            
            readOut = getReadOut()
            menuArray = menuReadArray()
            

        }
    }
    
    // Add a frame to a box
    func addFrame(boxid: UUID, height: Float, width: Float, honeyTotal: Float){
        for i in 0..<hiveList.count {
            for j in 0..<hiveList[i].beeBoxes.count{
                if boxid == hiveList[i].beeBoxes[j].id{
                    let newFrame = Frame(idx: hiveList[i].beeBoxes[j].frames.count, height: height, width: width, honeyTotal: honeyTotal)
                    hiveList[i].beeBoxes[j].frames.append(newFrame)
                    
                    readOut = getReadOut()
                    return
                }
            }
        }
    }
}
