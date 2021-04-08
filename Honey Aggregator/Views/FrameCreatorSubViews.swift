//
//  FrameCreatorSubViews.swift
//  Honey_Agg
//
//  All the sub views for the FrameCreator view
//
//  Special thanks to John Codeos
//  https://johncodeos.com/how-to-create-a-popup-window-with-swiftui/

import SwiftUI
import SwiftyDraw
import SwiftImage

// View for HiveCreator
struct HiveCreator: View{
    // Singleton object that holds list of hives
    @EnvironmentObject var hives:Hives
    
    // Binding variables that are connected to @State variables
    // in FrameCreator
    @Binding var state: STATE
    @Binding var selectedHive: Hive?
    @Binding var titleText: String
    
    @State private var tmpHiveName: String = ""
    
    var body: some View{
        VStack{
            HStack{
                Text("Hive:")
                    .padding()
                
                // Textfield for editing the new hive name
                TextField("Enter Name", text: $tmpHiveName)
                
                // Button for adding the new hive
                Button(action: {
                    hives.addHive(name: tmpHiveName)
                    tmpHiveName = ""
                }){
                    Image(systemName: "plus")
                        .imageScale(.large)
                        .padding()
                }
            }
            
            // List for displaying all the hives
            List{
                ForEach(hives.hiveList) { hive in
                    HStack{
                        // Tapping the hive name will move the FrameCreator to the SelectBox state
                        Text("\(hive.hiveName)")
                            .frame(maxWidth: .infinity)
                            .onTapGesture(perform: {
                                selectedHive = hive
                                state = STATE.SelectBox
                                titleText = "Select Box"
                                hives.save()
                            })
                            
                        Divider()
                        
                        // Tapping the trash icon will delete the hive
                        Image(systemName: "trash.fill")
                            .onTapGesture {
                                hives.deleteHive(hiveid: hive.id)
                                hives.save()
                            }
                    }
                }
            }
        }
    }
}

struct BoxCreator: View{
    
    // Singleton object that holds list of hives
    @EnvironmentObject var hives:Hives
    
    var selectedHive: Hive
    
    // Binding variables that are connected to @State variables
    // in FrameCreator
    @Binding var state: STATE
    @Binding var selectedBox: BeeBox?
    @Binding var titleText: String
    
    var body: some View{
        VStack{
            // List for displaying all the boxes in a specific hive
            List{
                ForEach(hives.getBoxes(hiveid: selectedHive.id)) { box in
                    HStack{
                        // Tapping the hive name will move the FrameCreator to the SelectFrame state
                        Text("Box \(box.idx)")
                            .frame(maxWidth: .infinity)
                            .onTapGesture(perform: {
                                selectedBox = box
                                state = STATE.SelectFrame
                                titleText = "Frames"
                            })
                
                        Divider()
                        
                        // Tapping the trash icon will delete the hive
                        Image(systemName: "trash.fill")
                            .onTapGesture {
                                hives.deleteBox(boxid: box.id)
                                hives.save()
                            }
                    }
                }
            }
        }
    }
}

struct FrameSelector: View{
    
    // Singleton object that holds list of hives
    @EnvironmentObject var hives:Hives
    
    var selectedBox: BeeBox
    
    // Binding variables that are connected to @State variables
    // in FrameCreator
    @Binding var state: STATE
    @Binding var titleText: String
    
    var body: some View{
        VStack{
            // List all the frames in a specific box
            List{
                ForEach(hives.getFrames(boxid: selectedBox.id)) { frame in
                    HStack{
                        Text("Frame \(frame.idx)")
                            .frame(maxWidth: .infinity)
                        
                        Divider()
                        
                        // Tapping the trash icon will delete the frame
                        Image(systemName: "trash.fill")
                            .onTapGesture {
                                hives.deleteFrame(frameid: frame.id)
                                hives.save()
                            }
                    }
                }
            }
        }
    }
}

struct TemplateSelector: View{
    
    // Singleton object that holds list of hives
    @EnvironmentObject var hives:Hives
    
    // Binding variables that are connected to @State variables
    // in FrameCreator
    @Binding var state: STATE
    @Binding var selectedTemplate: Template?
    @Binding var titleText: String
    
    var body: some View{
        VStack{
            // Button for creating a custom template and moving the FrameCreator
            // to the CustomTemplate state
            Button(action:{
                state = STATE.CustomTemplate
                titleText = "Custom Template"
            }){
                Text("Custom")
            }
            
            // List for showing all the templates and their dimensions
            List{
                ForEach(hives.templates){ template in
                    // Changes the unit information based on whether the hives object is isMetric
                    // or not
                    if hives.isMetric{
                        let heightString = String(format: "%.2f", template.height * 25.4)
                        let widthString = String(format: "%.2f", template.width * 25.4)
                        
                        // Tapping the template will move the FrameCreator to the Picture1Get state
                        Text("\(template.name) \nHeight: \(heightString) mm \nWidth:  \(widthString) mm")
                            .onTapGesture(perform: {
                            selectedTemplate = template
                            state = STATE.Picture1Get
                            titleText = "Side A Picture"
                        })
                    } else {
                        let heightString = String(format: "%.2f", template.height)
                        let widthString = String(format: "%.2f", template.width)
                        
                        // Tapping the template will move the FrameCreator to the Picture1Get state
                        Text("\(template.name) \nHeight: \(heightString) in \nWidth:  \(widthString) in")
                            .onTapGesture(perform: {
                            selectedTemplate = template
                            state = STATE.Picture1Get
                            titleText = "Side A Picture"
                        })
                    }
                }
            }
        }
    }
}

struct CustomTemplateCreator: View{
    @State private var showPopUp: Bool = false
    // Singleton object that holds list of hives
    @EnvironmentObject var hives:Hives
    
    // Binding variables that are connected to @State variables
    // in FrameCreator
    @Binding var state: STATE
    @Binding var selectedTemplate: Template?
    @Binding var titleText: String
    
    @State private var customName: String = ""
    @State private var customHeight: String = ""
    @State private var customWidth: String = ""
    
    var body: some View {
        VStack{
            // TextField for name of custom template
            TextField("Template Name", text: $customName)
                .padding()
            
            // TextField for height of custom template
            TextField("Enter Height", text: $customHeight)
                .padding()
                .keyboardType(.decimalPad)
            
            // TextField for width of custom template
            TextField("Enter Width",text: $customWidth)
                .padding()
                .keyboardType(.decimalPad)
            
            // Button for creating the new template
            Button(action: {
                if let floatHeight = Float(customHeight){
                    if let floatWidth = Float(customWidth){
                        if floatWidth <= 0 {
                            showPopUp.toggle()
                            
                        }
                        else if floatHeight <= 0 {
                            showPopUp.toggle()
                            
                        }
                        else{
                        // Convert the height and width is the isMetric is true
                        if hives.isMetric{
                            selectedTemplate = Template(name: customName, height: floatHeight / 25.4, width: floatWidth / 25.4)
                        } else {
                            selectedTemplate = Template(name: customName, height: floatHeight, width: floatWidth)
                        }
                        
                        state = STATE.Picture1Get
                        titleText = "Side A Picture"
                        }
                        
                    }
                }
            }){
              Text("Next")
            }
        }
        ZStack{
            PopUpView(title: "Error", message: "Sorry, the custom dimensions must be more than zero!", buttonText: "OK", show: $showPopUp)
        }
    }
}

// Setup for connecting the UIViewRepresentable to SwiftUI view
struct DrawingView: UIViewRepresentable{
    
    @Binding var drawView: SwiftyDrawView
    
    func makeUIView(context: Context) -> SwiftyDrawView {
        drawView
    }
    
    func updateUIView(_ uiView: SwiftyDrawView, context: Context) {
        
    }
}

struct PictureHandler: View{
    
    // Singleton object that holds list of hives
    @EnvironmentObject var hives:Hives
    
    var selectedTemplate: Template
    
    // Binding variables that are connected to @State variables
    // in FrameCreator
    @Binding var titleText: String
    @Binding var state: STATE
    @Binding var tempHoneyAmount: Float
    
    // State variables for image handeling
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    // Bool used to trigger the camera in the ImagePicker
    @State private var shouldPresentCamera = false
    
    // Bool used to trigger user choice for image selection
    @State private var shouldPresentActionSheet = false
    
    // Sub Finite State Machine for the DrawingView
    enum DrawingState {
        case GetPicture, DrawFrame, DrawHoney
    }
    
    // Set the starting sub state for the DrawingView
    @State private var subState = DrawingState.GetPicture
    
    // Setup the SwiftyDrawView and drawing width
    @State private var drawView = SwiftyDrawView()
    @State private var drawWidth: CGFloat = 5.0
    
    // Information for red (frame) and blue (honey) pixel counts
    @State var redPixels = 0
    @State var bluePixels = 0
    
    @State var honeyPercent: Float = 0.0
    
    var body: some View{
        VStack{
            if subState == DrawingState.GetPicture{
                // Display the image picker button icon
                ZStack{
                    Image(systemName: "circle")
                        .font(.system(size: 70.0))
                    
                    Image(systemName: "camera")
                        .font(.system(size: 40.0))
                }
                .onTapGesture {
                    // Will allow Action Sheet to be toggled on
                    self.shouldPresentActionSheet = true
                }
            } else {
                ZStack{
                    // Display image that was selected
                    Image(uiImage: inputImage!)
                        .resizable()
                        .scaledToFit()
                    
                    // Display the drawing view
                    DrawingView(drawView: $drawView)
                }
                
                // Slider controls the size of the drawing width
                Slider(value: $drawWidth, in: 0...50, onEditingChanged: self.changeBrushWidth)
                    .padding()
                
                HStack{
                    // Undo drawing button
                    Button(action: {
                        drawView.undo()
                    }){
                        Text("Undo")
                    }
                    
                    // Redo drawing button
                    Button(action: {
                        drawView.redo()
                    }){
                        Text("Redo")
                    }
                    
                    // Done drawing button
                    Button(action: {
                        drawingDone()
                    }){
                        Text("Done")
                    }
                }.padding()
            }
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: ChangeDrawingState) {
            
            // This call to the constructor brings up the ImagePicker
            // sourceType uses the ? to set up an if else condition for variable shouldPresentCamera: Bool
            ImagePicker(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: self.$inputImage)
        }
       
        // Call to Action Sheet constructor isPresented is a Bool value which calls Binding<Bool> shouldPresentActionSheet
        // Action Sheet lists buttons in top down order, i.e. Camera is at top, cancel is at bottom
        .actionSheet(isPresented: $shouldPresentActionSheet) {
            
            // This creates the action sheet
            () -> ActionSheet in
            
            // This gives the Action Sheet a title
            // This gives the action sheet a message for the user to read
            // The syntax "action:" is used to define any behavior that pressing a button will perform in the code
            ActionSheet(title: Text("Choose mode"), message: Text("Please choose your preferred mode to set your profile image"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
            
                // This will toggle the ImagePicker on
                self.showingImagePicker = true
                
                // This will cause ImagePicker to toggle the camera on
                self.shouldPresentCamera = true
            }),
            
            // This creates a "Photo Library" button
            ActionSheet.Button.default(Text("Photo Library"), action: {
            
                // This toggles the ImagePicker on
                self.showingImagePicker = true
                
                // This prevents the camera from toggling on
                self.shouldPresentCamera = false
            }),
            
            // This creates a "Cancel" button
            ActionSheet.Button.cancel()])
        }

    }
    
    // Change the drawing state
    func ChangeDrawingState(){
        subState = DrawingState.DrawFrame
        drawView.brush.color = Color(UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0))
    }
    
    // End the picture state and move the FrameCreator to Picture2Get and then the Finalize state
    func EndPictureState(){
        if state == STATE.Picture1Get{
            state = STATE.Picture2Get
            titleText = "Frame Side B"
        } else if state == STATE.Picture2Get{
            state = STATE.Finalize
            titleText = "Finalize"
        }
    }
    
    
    func drawingDone(){
        
        // Get the Screenshot of the current view
        var image: UIImage?
        
        let currentLayer = UIApplication.shared.keyWindow!.layer
        
        let currentScale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(currentLayer.frame.size, false, currentScale)
        
        guard let currentContext = UIGraphicsGetCurrentContext() else {return}
        
        currentLayer.render(in: currentContext)
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()

        // Convert the UIImage to the SwiftImage Image type
        let imageTest = SwiftImage.Image<RGBA<UInt8>>(uiImage: image!)
        
        // Get pixel counts of either frame or honey pixels based on current
        // DrawingState
        for x in 0..<imageTest.width{
            for y in 0..<imageTest.height{
                let pixel: String = imageTest[x, y].description
                if subState == DrawingState.DrawFrame{
                    if (pixel == "#FF0000FF"){
                        redPixels += 1
                    }
                } else {
                    if (pixel == "#0000FFFF"){
                        bluePixels += 1
                    }
                }
            }
        }
        
        // If we are done with the honey drawing state, then get the percent of frame pixels versus
        // honey pixels.
        if subState == DrawingState.DrawHoney{
            if redPixels > 0 && bluePixels > 0{
                if redPixels > bluePixels{
                    honeyPercent = Float(bluePixels) / Float(redPixels)
                } else {
                    honeyPercent = 1.0
                }
            }
            
            let frameHeight: Float = selectedTemplate.height
            let frameWidth: Float = selectedTemplate.width
            let honeyLBPerSquareIn: Float = 0.033
            
            // Caluclate the honey amount for one side of the frame and add it
            // to the tempHoneyAmount
            tempHoneyAmount += (frameWidth * frameHeight * honeyPercent * honeyLBPerSquareIn)
                        
            EndPictureState()
        } else {
            // Move to the DrawHoney state in the drawing view
            drawView.clear()
            drawView.brush.color = Color(UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0))
            subState = DrawingState.DrawHoney
        }
    }
    
    // Function for changing the drawing width
    func changeBrushWidth(changed: Bool) {
        drawView.brush.width = drawWidth
    }
}

