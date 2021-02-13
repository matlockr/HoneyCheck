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
    
    // Variable to reset file for testing purposes
    let fileReset = true
    
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
    
    // HiveList Functions
    func addHive(){
        let newHive = Hive(hiveName: "None", honeyTotal: 0.0, beeBoxes: [])
        hiveList.append(newHive)
    }
    
    // Hive Functions
    func getHiveName(hiveIndex: Int) -> String{
        return hiveList[hiveIndex].hiveName
    }
    
    func setHiveName(hiveIndex: Int, name: String){
        hiveList[hiveIndex].hiveName = name
    }
    
    func getHiveHoneyTotal(hiveIndex: Int) -> Float{
        return hiveList[hiveIndex].honeyTotal
    }
    
    func setHiveHoneyTotal(hiveIndex: Int, honeyTotal: Float){
        hiveList[hiveIndex].honeyTotal = honeyTotal
    }
    
    func getHiveBeeBoxes(hiveIndex: Int) -> [BeeBox]{
        return hiveList[hiveIndex].beeBoxes
    }
    
    func addBeeBox(hiveIndex: Int){
        let newBeeBox = BeeBox(honeyTotal: 0.0, frames: [])
        hiveList[hiveIndex].beeBoxes.append(newBeeBox)
    }
    
    // BeeBox Functions
    func getBeeBoxHoneyTotal(hiveIndex: Int, beeBoxIndex: Int) -> Float{
        return hiveList[hiveIndex].beeBoxes[beeBoxIndex].honeyTotal
    }
    
    func setBeeBoxHoneyTotal(hiveIndex: Int, beeBoxIndex: Int, honeyTotal: Float) {
        hiveList[hiveIndex].beeBoxes[beeBoxIndex].honeyTotal = honeyTotal
    }
    
    func getBeeBoxFrames(hiveIndex: Int, beeBoxIndex: Int) -> [Frame]{
        return hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames
    }
    
    func addFrame(hiveIndex: Int, beeBoxIndex: Int){
        let newFrame = Frame(height: 0.0, width: 0.0, honeyAmount: 0.0)
        hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames.append(newFrame)
    }
    
    // Frame Functions
    func setFrameHeight(hiveIndex: Int, beeBoxIndex: Int, frameIndex: Int, height: Float){
        hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames[frameIndex].height = height
    }
    
    func getFrameHeight(hiveIndex: Int, beeBoxIndex: Int, frameIndex: Int) -> Float{
        return hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames[frameIndex].height
    }
    
    func setFrameWidth(hiveIndex: Int, beeBoxIndex: Int, frameIndex: Int, width: Float){
        hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames[frameIndex].width = width
    }
    
    func getFrameWidth(hiveIndex: Int, beeBoxIndex: Int, frameIndex: Int) -> Float{
        return hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames[frameIndex].width
    }
    
    func setHoneyTotal(hiveIndex: Int, beeBoxIndex: Int, frameIndex: Int, honeyTotal: Float){
        hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames[frameIndex].honeyAmount = honeyTotal
    }
    
    func getHoneyTotal(hiveIndex: Int, beeBoxIndex: Int, frameIndex: Int) -> Float{
        return hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames[frameIndex].honeyAmount
    }
    
    func setPictureData(hiveIndex: Int, beeBoxIndex: Int, frameIndex: Int, data: Data){
        hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames[frameIndex].pictureData = data
    }
    
    func getPictureData(hiveIndex: Int, beeBoxIndex: Int, frameIndex: Int) -> Data?{
        return hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames[frameIndex].pictureData
    }
    
    // Honey Calculation Functions
    func setBeeBoxHoney(hiveIndex: Int, beeBoxIndex: Int){
        var frameHoneyTotal: Float = 0.0
        for frame in hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames{
            frameHoneyTotal += frame.honeyAmount
        }
        hiveList[hiveIndex].beeBoxes[beeBoxIndex].honeyTotal = frameHoneyTotal
        
        self.setHiveHoneyTotal(hiveIndex: hiveIndex)
    }
    
    func setHiveHoneyTotal(hiveIndex: Int){
        var boxesHoneyTotal: Float = 0.0
        for box in hiveList[hiveIndex].beeBoxes{
            boxesHoneyTotal += box.honeyTotal
        }
        hiveList[hiveIndex].honeyTotal = boxesHoneyTotal
    }
}
