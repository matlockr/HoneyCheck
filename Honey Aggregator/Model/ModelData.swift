//
//  ModelData.swift
//  Honey_Aggregator
//
//  Created by Robert Matlock on 3/19/21.
//  Special thanks to Sergey Kargopolov
//  https://www.appsdeveloperblog.com/check-if-a-file-exist/

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
    
    var isDrawingHandler: Bool = false
    
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
    
    //Checks to see if file is contained in file system
    func fileCheck(file: String)->String{
        var filePath = ""
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        //This check just makes sure we can right to the documents directory
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appendingFormat("/" + file)
            //print("Local path = \(filePath)")
        }
        else {
            return "Could not find local directory to store file"
        }
        let fileManager = FileManager.default
        // Check if file exists
        if fileManager.fileExists(atPath: filePath) {
            return "File exists"
        }
        else {
            return "File does not exist"
        }
    }
    
    // Save function encodes the hive information and saves it to a JSON file.
    func save(file: String){
        do {
            // Setup the encoder
            let encoder = JSONEncoder()
            var fileURL: URL
            // Attempt to encode the hivelist data
            let data = try encoder.encode(hiveList)
            if(file.isEmpty){
                // Get the correct directory path to save the hivelist data
                fileURL = dir.appendingPathComponent(fileName)
            }
           
            else{
                fileURL = dir.appendingPathComponent(file)
            }
            // Attempt to write to file
            try data.write(to: fileURL)
            
        } catch {
            fatalError("Couldn't save data to \(fileName)")
        }
    }
    
    //This function creates a .json of the current hive and archives it.
    func archive(file:String)->String{
        do {
            var contingency = ""
            //This is an error check and ensures a unique filename if somehow an empty string reaches this function
            if file.isEmpty{
                //Hasher is always a unique valeu
                var hasher = Hasher()
                file.hash(into: &hasher)
                //This adds the date to this random unique file name after parsing it for characters that would break the file system.  You may be able to refactor the parse.
                let today = "\(Date())".replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: ":", with: "").replacingOccurrences(of: "+", with: "")
                let hashIntoString = "\(hasher.finalize())"
                    contingency = "\(hashIntoString)date\(today).json".replacingOccurrences(of: "-", with: "")
            }
            //This is an error check for a string that does not contain the file type.  It shouldn't be possible to reach this branch
            else if !file.contains(".json"){
                if contingency.isEmpty{
                    contingency = "\(file).json"
                }
            }
            //This should be the only branch that can be reached.
            if contingency.isEmpty{
                print("The good branch")
                print(file)
                if(fileCheck(file: file) == "File exists" || fileCheck(file: file) == "Could not find local directory to store file"){
                    return "File name already in use."
                }
                // Setup the encoder
                save(file: file)
            }
            //This is a branch that should be impossible to reach but ensures any call to archive can be handled.
            else{
                print("Impressive very impressive")
                print("File is: \(file)")
                if(fileCheck(file: contingency) == "File exists" || fileCheck(file: contingency) == "Could not find local directory to store file"){
                    return "File name already in use."
                }
                // Setup the encoder
                save(file: contingency)
            }
            reset()
            return "Season was successfully archived!"
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
                        readOutString += "\t\t\tHoney Total: \(String(format: "%.2f", (hiveList[i].beeBoxes[j].frames[k].honeyTotalSideA + hiveList[i].beeBoxes[j].frames[k].honeyTotalSideB) / 2.20)) kg\n"
                    } else {
                        readOutString += "\t\t\tHoney Total: \(String(format: "%.2f", (hiveList[i].beeBoxes[j].frames[k].honeyTotalSideA + hiveList[i].beeBoxes[j].frames[k].honeyTotalSideB))) lbs\n"
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
                readOutString += "\tBox: \(j + 1)\n"
                for k in 0..<hiveList[tempIndex!].beeBoxes[j].frames.count{
                    readOutString += "\t\tFrame: \(k + 1) \n"
                
                    if isMetric{
                        readOutString += "\t\t\tHoney Total: \(String(format: "%.2f", (hiveList[tempIndex!].beeBoxes[j].frames[k].honeyTotalSideA + hiveList[tempIndex!].beeBoxes[j].frames[k].honeyTotalSideB) / 2.20)) kg\n"
                    } else {
                        readOutString += "\t\t\tHoney Total: \(String(format: "%.2f", hiveList[tempIndex!].beeBoxes[j].frames[k].honeyTotalSideA + hiveList[tempIndex!].beeBoxes[j].frames[k].honeyTotalSideB)) lbs\n"
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
        save(file: "")
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
    func addFrame(boxid: UUID, height: Float, width: Float, honeyTotalSideA: Float, honeyTotalSideB: Float){
        for i in 0..<hiveList.count {
            for j in 0..<hiveList[i].beeBoxes.count{
                if boxid == hiveList[i].beeBoxes[j].id{
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .short
                    let dateString = dateFormatter.string(from: Date())
                    
                    let newFrame = Frame(idx: hiveList[i].beeBoxes[j].frames.count, height: height, width: width, honeyTotalSideA: honeyTotalSideA, honeyTotalSideB: honeyTotalSideB, dateMade: dateString)
                    hiveList[i].beeBoxes[j].frames.append(newFrame)
                    
                    readOut = getReadOut()
                    return
                }
            }
        }
    }
}
