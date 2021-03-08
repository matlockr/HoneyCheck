//
//  FrameCreator.swift
//  Honey Aggregator
//
//  Screen for creating and editing frames for each
//  BeeBox
//  Additional thanks to @karthickselvaraj from Medium.com for sourceType information https://medium.com/better-programming/how-to-pick-an-image-from-camera-or-photo-library-in-swiftui-a596a0a2ece

import SwiftUI

struct FrameCreator: View {
    
    // Singleton for the list of hives
    @EnvironmentObject var hives:Hives
    
    var hiveIndex: Int
    var beeBoxIndex: Int
    var frameIndex: Int
    
    // State variables for holding information about textfields
    @State private var heightFieldText = ""
    @State private var widthFieldText = ""
    
    // State variables for image handeling
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    //Bool used to trigger the camera in the ImagePicker
    @State private var shouldPresentCamera = false
    
    //Bool used to trigger user choice for image selection
    @State private var shouldPresentActionSheet = false
    
    //used to store the unit type for each hive
    @State private var unitName = ""
    
    //This stores the user's frame dimensions currently supports one frame type per user
    @State private var frameDims = UserDefaults.standard.integer(forKey: "globalFrameFormat")
    @State private var isCustom: Bool = false
    
    @State private var shouldShowImageDrawer = false
    @State private var honeyPercent: Float = 0.0
    
    var body: some View {
        HStack{}.onAppear(perform: {
    
            //this is the call for the unitName to be parsed
            //The area value must be 1
            unitName = hives.setUnitReadout(unit: UserDefaults.standard.integer(forKey: "unitTypeGlobal"), area: 1)
            
            switch UserDefaults.standard.integer(forKey: "unitTypeGlobal"){
                case 0:
                    //this returns inches for frame dimensions
                    self.heightFieldText = String(hives.getFrameHeight(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex))
                    self.widthFieldText = String(hives.getFrameWidth(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex))
                
                default:
                    //this returns metric values for frame dimensions
                    self.heightFieldText = String(hives.convertUnitValue(value: hives.getFrameHeight(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex), direc: "in2\(unitName)"))
                    self.widthFieldText = String(hives.convertUnitValue(value: hives.getFrameWidth(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex), direc: "in2\(unitName)"))
            }
        })
        
        VStack{
            // Section for holding the dimensions
            Section{
                
                // Title to section
                Text("Dimensions")
                    .font(.title2)
                    .padding()
                
                Form{
                    Picker("Available Frame Formats", selection: $frameDims){
                        Group{
        
                            //These are frame standards
                            Text("American Langstroth").tag(0)
                            Text("Californian Langstroth").tag(1)
                            Text("Australian Langstroth").tag(2)
                            Text("Canadian Langstroth").tag(3)
                            Text("British Langstroth").tag(4)
                            Text("9 Frame British Langstroth").tag(5)
                            Text("11 Frame British Langstroth").tag(6)
                            Text("New Zealand Langstroth (Old Imperial)").tag(7)
                            Text("New Zealand Langstroth (New Metric Standard)").tag(8)
                            Text("8 Frame New Zealand Langstroth (New Metric Standard)").tag(9)
                        }
                        
                        Group{
                            Text("French Langstroth").tag(10)
                            Text("Danish 10 frame Langstroth (Swienty styropor) (Courtesy Swienty catalogue)").tag(11)
                            Text("Danish 13 frame Langstroth (Rea-dan Skinned polyurethane foam)").tag(12)
                            Text("Greek Langstroth").tag(13)
                            Text("Mexican Langstroth").tag(14)
                            Text("12 frame type used by Erik Osterlund").tag(15)
                            Text("Custom").tag(16)
                        }
                    }
                   
                    //checks if user selected a new frame format
                    .onChange(of: self.frameDims){_ in
                        if(self.frameDims < 16){
                            isCustom = false
                            UserDefaults.standard.set(self.frameDims, forKey: "globalFrameFormat")
                            hives.frameIndicator(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex, value: UserDefaults.standard.integer(forKey: "globalFrameFormat"))
                        }
                        
                        //this handles custom formats
                        else{
                            isCustom = true
                            UserDefaults.standard.set(self.frameDims, forKey: "globalFrameFormat")
                            
                            if(unitName != "in"){
                                if (widthFieldText != "" && heightFieldText != ""){
                                    hives.setFrameHeight(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex, height: hives.convertUnitValue(value: Float(heightFieldText) ?? 0.0, direc: "\(unitName)2in"))
                                    hives.setFrameWidth(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex, width: hives.convertUnitValue(value: Float(widthFieldText) ?? 0.0, direc: "\(unitName)2in"))
                                }
                            }
                            else{
                                hives.setFrameHeight(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex, height: Float(heightFieldText) ?? 0.0)
                                hives.setFrameWidth(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex, width: Float(widthFieldText) ?? 0.0)
                            }
                        }
                    }
                }
                .frame(height: 100)
                .clipped()
                
                if isCustom{
                    
                    // Hstack for getting the Height entered information
                    HStack{
                        Text("Height")
                            .padding()
                            
                        TextField("\(String(hives.getFrameHeight(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex)))", text: $heightFieldText, onEditingChanged: { didBegin in
                            //onEditingChanged checks to see if edits are being performed
                            if (didBegin){
                                //do nothing
                            }
                            //This is where custom dimensions are saved
                            else{
                                if(self.frameDims > 15){
                                    if(UserDefaults.standard.integer(forKey: "unitTypeGlobal") > 0){
                                        hives.setFrameHeight(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex, height: hives.convertUnitValue(value: Float(heightFieldText) ?? 0.0, direc: "\(unitName)2in"))
                                    }
                                    else{
                                        hives.setFrameHeight(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex, height:  Float(heightFieldText) ?? 0.0)
                                    }
                                }
                            }
                        })
                            .padding()
                            .keyboardType(.decimalPad)
                            
                        //this is where the name of the unit is displayed
                        Text("\(unitName)")
                            .padding()
                    }
                    // Hstack for getting the Width entered information
                    HStack{
                        Text("Width ")
                            .padding()
                        
                        TextField("\(String(hives.getFrameWidth(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex)))", text: $widthFieldText, onEditingChanged: { didBegin in
                                  //onEditingChanged checks to see if edits are being performed
                                  if (didBegin){
                                      // do nothing
                                  }
                                  //This is where custom dimensions are saved
                                  else{
                                      if(self.frameDims > 15){
                                          if(UserDefaults.standard.integer(forKey: "unitTypeGlobal") > 0){
                                              hives.setFrameWidth(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex, width: hives.convertUnitValue(value: Float(widthFieldText) ?? 0.0, direc: "\(unitName)2in"))
                                          }
                                          else{
                                              hives.setFrameWidth(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex, width:  Float(widthFieldText) ?? 0.0)
                                          }
                                      }
                                  }
                              })
                            .padding()
                            .keyboardType(.decimalPad)
                        
                        //this is where the name of the unit is displayed
                        Text("\(unitName)")
                            .padding()
                    }
                } else {
                    
                    // Hstack for getting the Height entered information
                    HStack{
                        Text("Height")
                            .padding()
                            
                        Text("\(String(hives.getFrameHeight(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex)))")
                            .padding()
                        
                        //this is where the name of the unit is displayed
                        Text("\(unitName)")
                            .padding()
                    }
                    
                    // Hstack for getting the Width entered information
                    HStack{
                        Text("Width ")
                            .padding()
                        
                        Text("\(String(hives.getFrameWidth(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex)))")
                            .padding()
                        //this is where the name of the unit is displayed
                        Text("\(unitName)")
                            .padding()
                    }
                }
            }
                
            Spacer()
            Divider()
            
            // Section for the Image getter
            Section{
                
                // Title to section
                Text("Picture")
                    .font(.title2)
                
                // Hstack for the frame picture and a button for
                // getting the picture.
                HStack{
                    Spacer()
                    ZStack{
                        if image != nil{
                            image?
                                .resizable()
                                .scaledToFit()
                        } else {
                            Image("comb")
                                .resizable()
                                .frame(width: 100, height: 100, alignment: .center)
                        }
                    }
                    
                    Spacer()
                    ZStack{
                        Image(systemName: "circle")
                            .font(.system(size: 70.0))
                        
                        Image(systemName: "camera")
                            .font(.system(size: 40.0))
                    }
                    .onTapGesture {
                        //will allow Action Sheet to be toggled on
                        self.shouldPresentActionSheet = true
                    }
                
                    Spacer()
                }
                
            }.disabled(false)
            Spacer()
            
            if let picdata = hives.getPictureData(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex){
                NavigationLink(destination: ImageDrawer(backgroundImage: UIImage(data: picdata) ?? nil, honeyPercent: $honeyPercent), isActive: self.$shouldShowImageDrawer){}
            }
            
            
            Divider()
            
            HStack{
                Button("Draw Details"){
                    shouldShowImageDrawer = true
                }.foregroundColor(.orange)
                
                // Save button for saving the frame
                // Currently just sends user back to last screen.
                Button("Save Frame") {
                    if (widthFieldText != "" && heightFieldText != ""){
                        
                        switch UserDefaults.standard.integer(forKey: "unitTypeGlobal") {
                            case 0:
                                hives.setFrameHeight(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex, height: Float(heightFieldText) ?? 0.0)
                                hives.setFrameWidth(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex, width: Float(widthFieldText) ?? 0.0)
                            default:
                                //this saves custom metric values as inches
                                hives.setFrameHeight(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex, height: hives.convertUnitValue(value: Float(heightFieldText) ?? 0.0, direc: "\(unitName)2in"))
                                hives.setFrameWidth(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex, width: hives.convertUnitValue(value: Float(widthFieldText) ?? 0.0, direc: "\(unitName)2in"))
                        }
                    }
                    
                    if (inputImage != nil){
                        if let data = inputImage?.jpegData(compressionQuality: 0.1){
                            hives.setPictureData(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex, data: data)
                        }
                    }
                    
                    // Get the frame square units
                    let frameSquareUnits = hives.getFrameWidth(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex) * hives.getFrameHeight(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex)
                    
                    
                    var honeyPerSquareUnitMuliplier: Float = 0.0
                    switch hives.setUnitReadout(unit: UserDefaults.standard.integer(forKey: "unitTypeGlobal"), area: 3){
                    case "lb":
                        honeyPerSquareUnitMuliplier = 0.017
                    case "kg":
                        honeyPerSquareUnitMuliplier = 0.0077
                    default:
                        honeyPerSquareUnitMuliplier = 0.0
                    }

                    hives.setHoneyTotal(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex, honeyTotal: honeyPercent * frameSquareUnits * honeyPerSquareUnitMuliplier)
                    hives.setBeeBoxHoney(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex)
                    hives.setHiveHoneyTotal(hiveIndex: hiveIndex)
                    hives.save()
                }.padding()
                .foregroundColor(.orange)
            }

        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            
            //This call to the constructor brings up the ImagePicker
            //sourceType uses the ? to set up an if else condition for variable shouldPresentCamera: Bool
            ImagePicker(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: self.$inputImage)
        }
       
        //Call to Action Sheet constructor isPresented is a Bool value which calls Binding<Bool> shouldPresentActionSheet
        //Action Sheet lists buttons in top down order, i.e. Camera is at top, cancel is at bottom
        .actionSheet(isPresented: $shouldPresentActionSheet) {
            
            //This creates the action sheet
            () -> ActionSheet in
            
            //This gives the Action Sheet a title
            //This gives the action sheet a message for the user to read
            //The syntax "action:" is used to define any behavior that pressing a button will perform in the code
            ActionSheet(title: Text("Choose mode"), message: Text("Please choose your preferred mode to set your profile image"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
            
                //This will toggle the ImagePicker on
                self.showingImagePicker = true
                
                //This will cause ImagePicker to toggle the camera on
                self.shouldPresentCamera = true
            }),
            
            //This creates a "Photo Library" button
            ActionSheet.Button.default(Text("Photo Library"), action: {
            
                //This toggles the ImagePicker on
                self.showingImagePicker = true
                
                //This prevents the camera from toggling on
                self.shouldPresentCamera = false
            }),
            
            //This creates a "Cancel" button
            ActionSheet.Button.cancel()])
        }
        .onAppear{
            convertImageFromData()
            shouldShowImageDrawer = false
            if UserDefaults.standard.integer(forKey: "globalFrameFormat") != 16{
                isCustom = false
            } else {
                isCustom = true
            }
        }
        .navigationBarTitle("Frame Creator")
        
    }
    
    // Takes the Data type variable in the Frame object and
    // converts it into a Swift Image type for placing in View
    func convertImageFromData(){
        if let picData =  hives.getPictureData(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex){
            image = Image(uiImage: UIImage(data: picData)!)
        }
    }
    
    func loadImage(){
        guard let inputImage = inputImage else {return}
        image = Image(uiImage: inputImage)
    }
}
