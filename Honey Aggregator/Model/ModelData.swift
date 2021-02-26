//
//  ModelData.swift
//  Honey Aggregator
//
//  Model Data decoder
//

import Foundation

class Hives: ObservableObject{

    let fileName = "hives.json"
    let dir: URL
    @Published var hiveList = [Hive]()
    // Variable to reset file for testing purposes
    let fileReset = false
    
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
        let newHive = Hive(hiveName: "None", honeyTotal: 0.0, honeyTotalKG: 0.0,  beeBoxes: [])
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
        let newBeeBox = BeeBox(name: "None", honeyTotal: 0.0, honeyTotalKG: 0.0, frames: [])
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
        let newFrame = Frame(height: 0.0, heightMet: 0.0, width: 0.0, widthMet: 0.0, honeyAmount: 0.0, honeyAmountMet: 0.0)
        hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames.append(newFrame)
    }
    
    func getBeeBoxName(hiveIndex: Int, beeBoxIndex: Int) -> String{
        return hiveList[hiveIndex].beeBoxes[beeBoxIndex].name
    }
    
    func setBeeBoxName(hiveIndex: Int, beeBoxIndex: Int, name: String) {
        hiveList[hiveIndex].beeBoxes[beeBoxIndex].name = name
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
    //This function takes a metric unit and converts it to another metric unit
    //You specify which conversion takes place with UserDefaults.standard.integer(forKey: "unitTypeGlobal")
    func convertUnitMetro(unit: Int, value: Float, area: Int)->Float{
        var send: Float
        send = 0.0
        switch area {
        //This should only be used for the FrameListRow
        //This converts kg to grams
        case 0:
            send = value * 1000
        default:
            //This should only be used inside the FrameCreator
            switch unit {
            //This turns meters to mm
            case 1:
                send = value * 1000
            //This turns meters to cm
            case 2:
                send = value * 100
            //This turns meters to dm
            case 3:
                send = value * 10
            //This returns meters
            default:
                send = value
            }
        }
        return send
    }
    //This mostly just transforms lbs to oz but incase I made any logical mistakes to make sure that inches get returned
    func convertUnitImp(unit: Int, value: Float, area: Int)->Float{
        var send: Float
        send = 0.0
        switch area {
        case 0:
            send = value * 16
        default:
            send = value
        }
        return send
    }
    //this func converts between unit values ie: oz to lbs, lbs to kg
    //unit: UserDefaults.standard.integer(forKey: "unitTypeGlobal"), area 0 should be used in FrameListRow any other value will cause the
    func convertUnitType(unit: Int, value: Float, area: Int)->Float{
        var send: Float
        send = 0.0
        switch unit {
        case 0:
            send = convertUnitImp(unit: unit, value: value, area: area)
        default:
            send = convertUnitMetro(unit: unit, value: value, area: area)
        }
        return send
    }
    //this func takes the value of the honeyTotal var or a length dimension and saves the data to the metric unit variable
    //You must specify whether you are sending weight or length data.  Use scale: 0 for length
    func convertUnitValue(value: Float, scale: Int)->Float{
        var send: Float
        var kg: Float
        var m: Float
        kg = (0.453592)
        m = (0.0254)
        switch scale {
        case 0:
            send = value * m
        default:
            send = value * kg
        }
        return send
    }
    //this sets the unit name for the frame previews
    func nameUnitFramePreview(unit: Int)->String{
        var send: String
        switch unit {
        case 0:
            send = "oz"
        default:
            send = "g"
        }
        return send
    }
    //this sets the unit name for the frame dimensions
    func nameUnitFrameActual(unit: Int)->String{
        var send: String
        switch unit {
        case 0:
            send = "in"
        case 2:
            send = "cm"
        case 3:
            send = "dm"
        case 4:
            send = "m"
        default:
            send = "mm"
        }
        return send
    }
    //this function sets the string that is the unit name
    func setUnitReadout(unit: Int, area: Int)->String{
        var send: String
        switch area{
        //special case that is for frame weight
            case 0:
                send = nameUnitFramePreview(unit: unit)
        //special case that is for frame dimensions
            case 1:
                send = nameUnitFrameActual(unit: unit)
            default:
                switch unit {
                case 0:
                    send = "lb"
                default:
                    send =  "KG"
            }
        }
        return send
    }
    //this func sends the unit formatting
    func unitSys(unit: Int)->String{
        var send: String
        switch unit {
        case 0:
            send = "Imperial: in/oz/lb"
        case 2:
            send = "Metric: cm/g/KG"
        case 3:
            send = "Metric: dm/g/KG"
        case 4:
            send = "Metric: m/g/KG"
        default:
            send = "Metric: mm/g/KG"
        }
        return send
    }
}
//Unassigned Topic
/*
//This limits the input of something to number only values
class Numerical: ObservableObject {
    @Published var value = "" {
        didSet {
            let filtered = value.filter { $0.isNumber }
                
            if value != filtered {
                value = filtered
            }
        }
    }
}
*/

