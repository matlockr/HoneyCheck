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
    //this holds the frame standards in inches
    var dimDict = [
        (height: Float(18.2677264), width: Float(16.3779616)),
        (height: Float(18.503947), width: Float(16.2598513)),
        (height: Float(18.2677264), width: Float(15.9842606)),
        (height: Float(18.4645769), width: Float(16.4567018)),
        (height: Float(18.2677264), width: Float(16.2598513)),
        (height: Float(18.2677264), width: Float(14.8031576)),
        (height: Float(18.2677264), width: Float(18.4252068)),
        (height: Float(18.2677264), width: Float(15.9842606)),
        (height: Float(18.3070965), width: Float(15.9448905)),
        (height: Float(18.3070965), width: Float(13.8976453)),
        (height: Float(17.7952852), width: Float(19.9212706)),
        (height: Float(18.2283563), width: Float(17.716545)),
        (height: Float(18.3070965), width: Float(20.0000108)),
        (height: Float(18.3070965), width: Float(16.4173317)),
        (height: Float(18.7795377), width: Float(15.9448905)),
        (height: Float(18.2677264), width: Float(20.0000108))
    ]
    //this holds the conversion values between units
    var convDict = [
        (name: "in2mm", rate: Float(25.4)),
        (name: "in2cm", rate: Float(2.54)),
        (name: "in2dm", rate: Float(0.254)),
        //where m is meter
        (name: "in2m", rate: Float(0.0254)),
        (name: "mm2in", rate: Float(0.0393701)),
        (name: "cm2in", rate: Float(0.393701)),
        (name: "dm2in", rate: Float(3.93701)),
        //where m is meter
        (name: "m2in", rate: Float(39.3701)),
        (name: "lb2oz", rate: Float(16)),
        (name: "lb2kg", rate: Float(0.453592)),
        (name: "lb2g", rate: Float(453.592)),
        (name: "kg2gram", rate: Float(1000))
    ]
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
        let newBeeBox = BeeBox(name: "None", honeyTotal: 0.0, frames: [])
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
    
    func getBeeBoxName(hiveIndex: Int, beeBoxIndex: Int) -> String{
        return hiveList[hiveIndex].beeBoxes[beeBoxIndex].name
    }
    
    func setBeeBoxName(hiveIndex: Int, beeBoxIndex: Int, name: String) {
        hiveList[hiveIndex].beeBoxes[beeBoxIndex].name = name
    }
    
    // Frame Functions
    func setFrameHeight(hiveIndex: Int, beeBoxIndex: Int, frameIndex: Int, height: Float){
        hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames[frameIndex].height = height
        //hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames[frameIndex].heightMet = convertUnitValue(value: hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames[frameIndex].height, direc: "in2m")
    }
    //returns the height of a frame
    func getFrameHeight(hiveIndex: Int, beeBoxIndex: Int, frameIndex: Int) -> Float{
        return hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames[frameIndex].height
    }
    
    func setFrameWidth(hiveIndex: Int, beeBoxIndex: Int, frameIndex: Int, width: Float){
        hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames[frameIndex].width = width
        //hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames[frameIndex].widthMet = convertUnitValue(value: hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames[frameIndex].width, direc: "in2m")
    }
    
    func getFrameWidth(hiveIndex: Int, beeBoxIndex: Int, frameIndex: Int) -> Float{
        return hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames[frameIndex].width
    }
    
    func setHoneyTotal(hiveIndex: Int, beeBoxIndex: Int, frameIndex: Int, honeyTotal: Float){
        hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames[frameIndex].honeyAmount = honeyTotal
        //hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames[frameIndex].honeyAmountMet = convertUnitValue(value: hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames[frameIndex].honeyAmount, direc: "lb2kg")
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
    //This func can convert a value
    //Direc indicates what the unit being converted is i.e. "in2mm"
    func convertUnitValue(value: Float, direc: String)->Float{
        var send: Float
        send = 0.0
        //this searches the dictionary for the conversion rate
        let found = convDict.firstIndex(where: {$0.name == direc})
        if ((found) != nil){
            let rate = convDict[found!].rate
            //this converts the unit values
            send = value * rate
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
    func frameIndicator(hiveIndex: Int, beeBoxIndex: Int, frameIndex: Int, value: Int){
        setFrameHeight(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex, height: dimDict[value].height)
        setFrameWidth(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex, width: dimDict[value].width)
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

