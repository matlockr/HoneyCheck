import SwiftUI
import SwiftyDraw
import SwiftImage
import Mantis
import UIKit
import CoreML

// View for HiveCreator
struct HiveCreator: View{
    // Singleton object that holds list of hives
    @EnvironmentObject var hives:Hives
    
    // Vars for Deletion Alerts
    @State var showDeleteAlert = false
    @State var tmpHive: Hive?
    
    // Binding variables that are connected to @State variables
    // in FrameCreator
    @Binding var state: STATE
    @Binding var selectedHive: Hive?
    @Binding var titleText: String
    
    // Manages length of text box inputs
    class TextFieldManager: ObservableObject{
        
        // Control for Hive Name Length
        @Published var text = "" {
            didSet{
                if text.count > charLimit && oldValue.count <= charLimit{
                    text = oldValue
                }
            }
        }
        
        let charLimit : Int
        
        init(limit: Int = 5){
            charLimit = limit
        }
    }
    
    // Length Managed Hive Name Variable (Change number to change the length limit)
    @ObservedObject var tmpHiveName = TextFieldManager(limit: 15)

    var body: some View{
        VStack{
            HStack{
                Text("New Hive:")
                    .padding()
                                
                // Textfield for editing the new hive name
                TextField("Enter Name", text: $tmpHiveName.text)
                
                // Button for adding the new hive
                Button(action: {
                    hives.addHive(name: tmpHiveName.text)
                    hives.save(file: "")
                    tmpHiveName.text = ""
                }){
                    Image(systemName: "plus")
                        .imageScale(.large)
                        .padding()
                        .foregroundColor(Color.orange)
                }
            }
            .background(Color(red: 255/255, green: 248/255, blue: 235/255))
            .cornerRadius(10)
            
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
                                hives.save(file: "")
                            })
                            
                        Divider()
                        
                        // Tapping the trash icon will delete the hive
                        Image(systemName: "trash.fill")
                            .onTapGesture {
                                tmpHive = hive
                                self.showDeleteAlert.toggle()
                            }
                            .foregroundColor(Color.red)
                    }
                    .alert(isPresented: $showDeleteAlert) { () -> Alert in
                        let pButton = Alert.Button.destructive(Text("Delete")){
                            hives.deleteHive(hiveid: tmpHive!.id)
                            hives.save(file: "")
                        }
                        let sButton = Alert.Button.cancel(Text("Cancel"))
                        return Alert(title: Text("WARNING"), message: Text("Are you sure you want to delete this Hive?"),
                                     primaryButton: pButton, secondaryButton: sButton)
                    }
                }
            }
        }
    }
}

// View for the BoxCreator
struct BoxCreator: View{
    
    // Singleton object that holds list of hives
    @EnvironmentObject var hives:Hives
    
    // Vars for Deletion Alerts
    @State var showDeleteAlert = false
    @State var tmpBox: BeeBox?
    
    // Holds the current hive this set of boxes resides in
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
                        Text("Box \(box.idx + 1)")
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
                                tmpBox = box
                                self.showDeleteAlert.toggle()
                            }
                            .foregroundColor(Color.red)
                    }
                    .alert(isPresented: $showDeleteAlert) { () -> Alert in
                        let pButton = Alert.Button.destructive(Text("Delete")){
                            hives.deleteBox(boxid: tmpBox!.id)
                            hives.save(file: "")
                        }
                        let sButton = Alert.Button.cancel(Text("Cancel"))
                        return Alert(title: Text("WARNING"), message: Text("Are you sure you want to delete this Box?"),
                                     primaryButton: pButton, secondaryButton: sButton)
                    }
                }
            }
        }
    }
}

// View for FrameSelector to add/delete frames
struct FrameSelector: View{
    
    // Singleton object that holds list of hives
    @EnvironmentObject var hives:Hives
    
    // Vars for Deletion Alerts
    @State var showDeleteAlert = false
    @State var tmpFrame: Frame?
    
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
                        Text("Frame \(frame.idx + 1)")
                            .frame(maxWidth: .infinity)
                        
                        Divider()
                        
                        // Tapping the trash icon will delete the frame
                        Image(systemName: "trash.fill")
                            .onTapGesture {
                                tmpFrame = frame
                                self.showDeleteAlert.toggle()
                            }
                            .foregroundColor(Color.red)
                    }
                    .alert(isPresented: $showDeleteAlert) { () -> Alert in
                        let pButton = Alert.Button.destructive(Text("Delete")){
                            hives.deleteFrame(frameid: tmpFrame!.id)
                            hives.save(file: "")
                        }
                        let sButton = Alert.Button.cancel(Text("Cancel"))
                        return Alert(title: Text("WARNING"), message: Text("Are you sure you want to delete this Frame?"),
                                     primaryButton: pButton, secondaryButton: sButton)
                    }
                }
            }
        }
    }
}

// View for the template selector
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
                Text("Custom Template")
                    .foregroundColor(Color.orange)
                    .padding(10)
                    .background(Color(red: 255/255, green: 248/255, blue: 235/255))
                    .cornerRadius(10)
                    .font(.system(size: 20, weight: .heavy))
            }
            .padding(.top)
            
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
        .onAppear(perform: {
            hives.loadTemplates()
        })
    }
}

// View for the Custom Template Maker View
struct CustomTemplateCreator: View{
    //This allows for multiple action sheets in this sub view.
    enum Sheets: Identifiable {
            case popUpView

            var id: Int {
                self.hashValue
            }
        }
    
    // Singleton object that holds list of hives
    @EnvironmentObject var hives:Hives
    
    // Binding variables that are connected to @State variables
    // in FrameCreator
    @Binding var state: STATE
    @Binding var selectedTemplate: Template?
    @Binding var titleText: String
    
    //activeSheet is used to add child sheets
    @State var activeSheet: Sheets?
    
    // Vars for custom template inputs
    @State private var customTemplateName: String = ""
    @State private var customTemplateHeight: String = ""
    @State private var customTemplateWidth: String = ""
    
    var body: some View {
        VStack{
            
            VStack{
                Text("Template Name")
                    .font(.title3)
                    .padding()
                // TextField for name of custom template
                TextField("Enter Name", text: $customTemplateName)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 255/255, green: 248/255, blue: 235/255)))
                
                Text("Template Height")
                    .font(.title3)
                    .padding()
                
                // TextField for height of custom template
                TextField("Enter Height", text: $customTemplateHeight)
                    .padding()
                    .keyboardType(.decimalPad)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 255/255, green: 248/255, blue: 235/255)))
                
                Text("Template Width")
                    .font(.title3)
                    .padding()
                
                // TextField for width of custom template
                TextField("Enter Width",text: $customTemplateWidth)
                    .padding()
                    .keyboardType(.decimalPad)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 255/255, green: 248/255, blue: 235/255)))
                    
            }.padding()
            
            // Button for creating the new template
            Button(action: {
                if let floatHeight = Float(customTemplateHeight){
                    if let floatWidth = Float(customTemplateWidth){
                        if floatWidth <= 0 {
                            self.activeSheet = .popUpView
                            
                        }
                        else if floatHeight <= 0 {
                            self.activeSheet = .popUpView
                            
                        } else {
                            // Convert the height and width is the isMetric is true
                            if hives.isMetric{
                                selectedTemplate = Template(name: customTemplateName, height: Float(floatHeight) / 25.4, width: Float(floatWidth) / 25.4)
                            } else {
                                selectedTemplate = Template(name: customTemplateName, height: Float(floatHeight), width: Float(floatWidth))
                            }
                            hives.templates.append(selectedTemplate!)
                            hives.saveTemplates()
                            state = STATE.Picture1Get
                            titleText = "Side A Picture"
                        }
                    }
                }
            }){
              Text("Next")
                .foregroundColor(Color.orange)
                .padding(10)
                .background(Color(red: 255/255, green: 248/255, blue: 235/255))
                .cornerRadius(10)
                .font(.system(size: 18, weight: .heavy))
            }.padding(.bottom)
            
        }
        .sheet(item: $activeSheet, onDismiss: { activeSheet = nil }) { item in
            switch item {
            //This brings up the warning screen.
            case .popUpView:
                PopUpView(title: "Error", message: "Sorry, the custom dimensions must be more than zero!", buttonText: "OK")
            }
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

// View for doing the drawing image processing
struct PictureHandler: View{

    // Singleton object that holds list of hives
    @EnvironmentObject var hives:Hives
 
    var selectedTemplate: Template
    
    // Binding variables that are connected to @State variables
    // in FrameCreator
    @Binding var titleText: String
    @Binding var state: STATE
    @Binding var tempHoneyAmount: Float
    @Binding var sideAHoneyAmount: Float
    @Binding var sideBHoneyAmount: Float
    
    // State variables for image handeling
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var showPopOver: Bool = false
    
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
    
    var body: some View {
        VStack{
            if subState == DrawingState.GetPicture{
                // Display the image picker button icon
                ZStack{
                    Image(systemName: "circle.fill")
                        .font(.system(size: 70.0))
                        .foregroundColor(Color(red: 255/255, green: 248/255, blue: 235/255))
                    
                    Image(systemName: "camera.fill")
                        .font(.system(size: 40.0))
                        .foregroundColor(Color.orange)
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
                    //Button with the other drawing tools for the tutorial popover view that describes the usage of the drawing program to the user.
                    Button(action: {
                        showPopOver.toggle()
                    }){
                        Text("Tutorial")
                            .foregroundColor(Color.orange)
                    }
                    .popover(isPresented: $showPopOver) {
                        Text("Drawing Tutorial")
                            .foregroundColor(Color.orange)
                            .font(.system(size: 20, weight: .heavy))
                            .padding(.horizontal)
                        Text("To calculatue the amount of honey you will need to draw in two sections. \n\nFirst: Draw with the red pen over the buildable comb area and hit done to go to the next step. \n\nSecond: Draw with the blue pen over where honey should be present. \n\nYou can edit the size of the pen on both steps with the slider.")
                        .padding()
                        .frame(width:320, height: 400)
                        Button(action: {
                            showPopOver.toggle()
                        }){
                            Text("Done")
                                .foregroundColor(Color.orange)
                                .padding(10)
                                .background(Color(red: 255/255, green: 248/255, blue: 235/255))
                                .cornerRadius(10)
                                .font(.system(size: 20, weight: .heavy))
                                .pickerStyle(MenuPickerStyle())
                        }
                    }
                    // Undo drawing button
                    Button(action: {
                        drawView.undo()
                    }){
                        Text("Undo")
                            .foregroundColor(Color.orange)
                    }
                    
                    // Redo drawing button
                    Button(action: {
                        drawView.redo()
                    }){
                        Text("Redo")
                            .foregroundColor(Color.orange)
                    }
                    
                    // Done drawing button
                    Button(action: {
                        drawingDone()
                    }){
                        Text("Done")
                            .foregroundColor(Color.orange)
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
        if inputImage != nil{
            subState = DrawingState.DrawFrame
            drawView.brush.color = Color(UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0))
        }
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
    
    // Calculate the honey amount using pixel counts of the comb and honey selections
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
            let honeyLBPerSquareIn: Float = 0.028
            
            // Caluclate the honey amount for one side of the frame and add it
            // to the tempHoneyAmount
            tempHoneyAmount += (frameWidth * frameHeight * honeyPercent * honeyLBPerSquareIn)
            
            if state == .Picture1Get{
                sideAHoneyAmount = tempHoneyAmount
            } else {
                sideBHoneyAmount = tempHoneyAmount - sideAHoneyAmount
            }
                        
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

// Struct view for the Automated picture handler
struct AutomatedPictureHandler: View{
    
    // Selected Template used for getting the height and width of image when slicing
    var selectedTemplate: Template
    
    // Binding variables that are connected to @State variables
    // in FrameCreator
    @Binding var titleText: String
    @Binding var state: STATE
    @Binding var honeyTotal: Float
    @Binding var sideAHoneyAmount: Float
    @Binding var sideBHoneyAmount: Float
    
    // State variables for image handeling
    @State private var showingImagePicker = false
    @State private var inputImage : UIImage?
    
    // Bool used to trigger the camera in the ImagePicker
    @State private var shouldPresentCamera = false
    
    // Bool used to trigger user choice for image selection
    @State private var shouldPresentActionSheet = false
    
    // Done variable used for triggering the transition between states
    @State private var done: Bool = false
    
    var body: some View{
        VStack{
            
            // Shows the image imported
            if (inputImage != nil){
                Image(uiImage: inputImage!)
                    .resizable()
                    .scaledToFit()
            }
            
            // Button for getting the image from the photo library
            // or the camera.
            ZStack{
                Image(systemName: "circle.fill")
                    .font(.system(size: 70.0))
                    .foregroundColor(Color(red: 255/255, green: 248/255, blue: 235/255))
                
                Image(systemName: "camera.fill")
                    .font(.system(size: 40.0))
                    .foregroundColor(Color.orange)
            }
            .onTapGesture {
                // Will allow Action Sheet to be toggled on
                self.shouldPresentActionSheet = true
            }
            
            // Navigation link button for cropping the image and doing the
            // Automated image classification.
            if (inputImage != nil){
                NavigationLink(destination: DetailedView(img: $inputImage, honeyTotal: $honeyTotal, done: $done, sideAHoneyAmount: $sideAHoneyAmount, sideBHoneyAmount: $sideBHoneyAmount, state: state, dimWidth: Int(selectedTemplate.width - 0.71), dimHeight: Int(selectedTemplate.height - 0.71)).onDisappear(perform: {
                    
                    // When classification is done, then transition to next state
                    if done{
                        if state == STATE.Picture1Get{
                            state = STATE.Picture2Get
                            titleText = "Frame Side B"
                        } else if state == STATE.Picture2Get{
                            state = STATE.Finalize
                            titleText = "Finalize"
                        }
                    }
                })
                ){
                    Text("Next")
                        .foregroundColor(Color.orange)
                        .padding(10)
                        .background(Color(red: 255/255, green: 248/255, blue: 235/255))
                        .cornerRadius(10)
                        .font(.system(size: 20, weight: .heavy))
                }
                .padding(.top)
            }
        }
        .sheet(isPresented: $showingImagePicker) {
        
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
}

// DetailedView handles the cropping view and the image classification
struct DetailedView: View {

    // Used to dismiss the view when done
    @Environment(\.presentationMode) var presentation

    // Binding variables from the AutomatedPictureHandler View
    @Binding var img: UIImage?
    @Binding var honeyTotal: Float
    @Binding var done: Bool
    @Binding var sideAHoneyAmount: Float
    @Binding var sideBHoneyAmount: Float
    var state: STATE
    
    // Show/hide cropping view
    @State private var showCropper: Bool = false
    @State private var showCropperButton: Bool = true
    @State private var showPopOver: Bool = false
   
    // Information about ML Classification
    @State private var predictionUIImages: [UIImage] = []
    @State private var honeyCount: Int = 0
    @State private var imgCountCurrent: Int = 0
    
    // UI toggles for showing/hiding buttons and bars
    @State private var isLoading: Bool = false
    @State private var showLoadingBar: Bool = false
    @State private var showAnaylseButton: Bool = false
    @State private var downloadAmount = 0.0
    
    // Timer for handleing switching between ML classification and updating view
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    // Dimension of frame in integer form
    var dimWidth: Int
    var dimHeight: Int

    var body: some View{
        VStack{
            
            if (showCropperButton == true){
                Button(action: {
                    showCropper = true
                }){
                    Text("Crop Image")
                        .foregroundColor(Color.orange)
                        .padding(10)
                        .background(Color(red: 255/255, green: 248/255, blue: 235/255))
                        .cornerRadius(10)
                        .font(.system(size: 20, weight: .heavy))
                }.padding()
                
                //Button with the other drawing tools for the tutorial popover view that describes the usage of the drawing program to the user.
                Button(action: {
                    showPopOver.toggle()
                }){
                    Text("Tutorial")
                        .foregroundColor(Color.orange)
                        .padding(10)
                        .background(Color(red: 255/255, green: 248/255, blue: 235/255))
                        .cornerRadius(10)
                        .font(.system(size: 20, weight: .heavy))
                }
                .popover(isPresented: $showPopOver) {
                    Text("Cropping Tutorial")
                        .foregroundColor(Color.orange)
                        .font(.system(size: 20, weight: .heavy))
                        .padding(.horizontal)
                    Text("To calculatue the amount of honey you will need to crop the image to the buildable comb of the frame. After the cropping is done, then select the Analyze Image button to start.")
                    .padding()
                    .frame(width:320, height: 400)
                }
            }
            // Loading bar based on how many images left to classify
            // for better user feedback
            if showLoadingBar{
                ProgressView("Analyzing Image", value: downloadAmount, total: Double(predictionUIImages.count))
                    .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                    .padding()
                    .foregroundColor(Color.orange)
            }
            
            // Analyze button appears when the cropping is done
            if showAnaylseButton {
                Button(action: {
                    showAnaylseButton = false
                    showCropperButton = false
                    showLoadingBar = true
                    
                    // DispatchQueue delays the code to allow the view to update
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        CropImage()
                    }
                }){
                    Text("Anaylze Image")
                        .foregroundColor(Color.orange)
                        .padding(10)
                        .background(Color(red: 255/255, green: 248/255, blue: 235/255))
                        .cornerRadius(10)
                        .font(.system(size: 20, weight: .heavy))
                }
                .padding()
            }
            
            
        }.navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $showCropper, onDismiss: {
            showAnaylseButton = true
        }){
            // Show the cropping view
            ImageEditor(theImage: $img).ignoresSafeArea()
        }
        .onReceive(timer){ _ in
            // When we are in the classification stage, everytime the timer activates
            // grab the next image to be classified.
            if isLoading{
                downloadAmount = Double(imgCountCurrent)
                if imgCountCurrent < predictionUIImages.count{
                    if imgCountCurrent + 9 < predictionUIImages.count{
                        MLPrediction(batch: true)
                    } else{
                        MLPrediction(batch: false)
                    }
                } else {
                    // Stop timer if out of images to classify
                    timer.upstream.connect().cancel()
                }
            }
        }
    }
    
    // Function for slicing the cropped image
    func CropImage(){
        
        // Slice images based on frame dimensions
        let originalImage = SwiftImage.Image<RGBA<UInt8>>(uiImage: img!)
        
        var croppingImgWidth: Int = originalImage.width
        var croppingImgHeight: Int = originalImage.height
        
        // Set max width of slice based on what image width divisablilty
        for i in stride(from: originalImage.width, to: 0, by: -1){
            if i % dimWidth == 0{
                croppingImgWidth = i
                break
            }
        }
        
        // Set max height of slice based on what image width divisablilty
        for i in stride(from: originalImage.height, to: 0, by: -1){
            if i % dimHeight == 0{
                croppingImgHeight = i
                break
            }
        }
        
        // Get the amount of pixels the width and height would be
        let wPixels: Int = croppingImgWidth / dimWidth
        let hPixels: Int = croppingImgHeight / dimHeight
        
        
        // Slice square inch sized images of the original image and append them
        // to a list of UIImages
        for w in 0..<dimWidth{
            for h in 0..<dimHeight{
                let slice: ImageSlice<RGBA<UInt8>> = originalImage[
                    (w * wPixels)..<(w * wPixels + wPixels),
                    (h * hPixels)..<(h * hPixels + hPixels)]
                let tmpImg: UIImage = (SwiftImage.Image<RGBA<UInt8>>(slice)).uiImage
                predictionUIImages.append(tmpImg)
            }
        }
        // Start the loading process
        isLoading = true
    }
    
    // Function for classifying a single square inch image
    func MLPrediction(batch: Bool){
        do{
            
            // Setup the ML model
            let config = MLModelConfiguration()
            let classifier = try CombClassifierFinal_1(configuration: config)
            
            if batch{
                for i in 0..<10{
                    // Resize the image
                    let resizedImage = predictionUIImages[imgCountCurrent + i].resizeTo(size: CGSize(width: 299, height: 299))
                    
                    // Conver the UIImage to a CVPixelBuffer
                    guard let buffer = resizedImage!.toBuffer() else {
                        print("ERROR when getting buffer")
                        return
                    }
                    
                    // Attempt to get a prediction from the ML model
                    let output = try? classifier.prediction(image: buffer)
                    
                    // Increment honeyCount if the image is labeled as "Honey"
                    if output?.classLabel != nil && output!.classLabel == "Honey" {
                        honeyCount += 1
                    }
                }
                imgCountCurrent += 10
            } else {
                for i in 0..<predictionUIImages.count-imgCountCurrent{
                    // Resize the image
                    let resizedImage = predictionUIImages[imgCountCurrent + i].resizeTo(size: CGSize(width: 299, height: 299))
                    
                    // Conver the UIImage to a CVPixelBuffer
                    guard let buffer = resizedImage!.toBuffer() else {
                        print("ERROR when getting buffer")
                        return
                    }
                    
                    // Attempt to get a prediction from the ML model
                    let output = try? classifier.prediction(image: buffer)
                    
                    // Increment honeyCount if the image is labeled as "Honey"
                    if output?.classLabel != nil && output!.classLabel == "Honey" {
                        honeyCount += 1
                    }
                }
                imgCountCurrent = predictionUIImages.count
                HoneyCalculation()
            }
        } catch {
        }
    }
    
    // Function for calculating the honey amount based on
    func HoneyCalculation(){
        let honeyPercent: Float = Float(honeyCount) / Float(predictionUIImages.count)
        
        let honeyLBPerSquareIn: Float = 0.028
        honeyTotal += (Float(dimWidth * dimHeight) * honeyPercent * honeyLBPerSquareIn)

        // Start the transistion to the next state
        done = true
        
        print(honeyCount)
        print(dimHeight)
        print(dimWidth)
        
        if state == .Picture1Get{
            sideAHoneyAmount = (Float(dimWidth * dimHeight) * honeyPercent * honeyLBPerSquareIn)
        } else {
            sideBHoneyAmount = (Float(dimWidth * dimHeight) * honeyPercent * honeyLBPerSquareIn)
        }
        
        //Dismiss the view
        self.presentation.wrappedValue.dismiss()
    }
}

// Struct UIView for connecting the Mantis Cropping view to SwiftUI
struct ImageEditor: UIViewControllerRepresentable{

    @Environment(\.presentationMode) var presentationMode
    
    // Binding variables for the image being cropped and
    // if the cropping view is showing.
    @Binding var theImage: UIImage?
    
    // ImageEditor Coordinator setup for using the Mantis Cropping View
    class Coordinator: CropViewControllerDelegate{
        
        var parent: ImageEditor

        init(_ parent: ImageEditor){
            self.parent = parent
        }

        func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
            parent.theImage = cropped
            parent.presentationMode.wrappedValue.dismiss()
        }

        func cropViewControllerDidFailToCrop(_ cropViewController: CropViewController, original: UIImage) {}

        func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) { parent.presentationMode.wrappedValue.dismiss() }

        func cropViewControllerDidBeginResize(_ cropViewController: CropViewController){}

        func cropViewControllerDidEndResize(_ cropViewController: CropViewController, original: UIImage, cropInfo: CropInfo) {}

        func cropViewControllerWillDismiss(_ cropViewController: CropViewController) {}
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageEditor>) -> Mantis.CropViewController {
        let cropViewController = Mantis.cropViewController(image: theImage!, config: Mantis.Config())
        cropViewController.delegate = context.coordinator
        return cropViewController
    }
}
