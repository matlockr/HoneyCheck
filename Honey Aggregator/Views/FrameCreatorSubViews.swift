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
import Mantis
import UIKit
import CoreML

// View for HiveCreator
struct HiveCreator: View{
    // Singleton object that holds list of hives
    @EnvironmentObject var hives:Hives
    
    // Binding variables that are connected to @State variables
    // in FrameCreator
    @Binding var state: STATE
    @Binding var selectedHive: Hive?
    @Binding var titleText: String
    
    // Manages length of text box inputs
    class TextFieldManager: ObservableObject{
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
                Text("Hive:")
                    .padding()
                                
                // Textfield for editing the new hive name
                TextField("Enter Name", text: $tmpHiveName.text)
                
                // Button for adding the new hive
                Button(action: {
                    hives.addHive(name: tmpHiveName.text)
                    tmpHiveName.text = ""
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

// Struct view for the Automated picture handler
struct AutomatedPictureHandler: View{
    
    // Selected Template used for getting the height and width of image when slicing
    var selectedTemplate: Template
    
    // Binding variables that are connected to @State variables
    // in FrameCreator
    @Binding var titleText: String
    @Binding var state: STATE
    @Binding var honeyTotal: Float
    
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
                Image(systemName: "circle")
                    .font(.system(size: 70.0))
                
                Image(systemName: "camera")
                    .font(.system(size: 40.0))
            }
            .onTapGesture {
                // Will allow Action Sheet to be toggled on
                self.shouldPresentActionSheet = true
            }
            
            // Navigation link button for cropping the image and doing the
            // Automated image classification.
            if (inputImage != nil){
                NavigationLink(destination: DetailedView(img: $inputImage, honeyTotal: $honeyTotal, done: $done, dimWidth: Int(selectedTemplate.width), dimHeight: Int(selectedTemplate.height)).onDisappear(perform: {
                    
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
                    Text("Crop Image")
                }
                .padding()
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
    
    // Show/hide cropping view
    @State private var showCropper: Bool = true
   
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
            // Loading bar based on how many images left to classify
            // for better user feedback
            if showLoadingBar{
                ProgressView("Analyzing Image", value: downloadAmount, total: Double(predictionUIImages.count))
                    .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                    //.progressViewStyle(CircularProgressViewStyle(tint: .orange))
                    //.scaleEffect(2)
                    .padding()
            }
            
            // Analyze button appears when the cropping is done
            if showAnaylseButton {
                Button(action: {
                    showAnaylseButton = false
                    showLoadingBar = true
                    
                    // DispatchQueue delays the code to allow the view to update
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        CropImage()
                    }
                }){
                    Text("Anaylze Image")
                }
            }
            
            
        }.fullScreenCover(isPresented: $showCropper, onDismiss: {showAnaylseButton = true}){
            
            // Show the cropping view
            ImageEditor(theImage: $img, isShowing: $showCropper)
        }
        .onReceive(timer){ _ in
            // When we are in the classification stage, everytime the timer activates
            // grab the next image to be classified.
            if isLoading{
                downloadAmount = Double(imgCountCurrent)
                if imgCountCurrent < predictionUIImages.count{
                    MLPrediction()
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
    func MLPrediction(){
        do{
            
            // Setup the ML model
            let config = MLModelConfiguration()
            let classifier = try CombClassifierSqInch(configuration: config)
            
            // Resize the image
            let resizedImage = predictionUIImages[imgCountCurrent].resizeTo(size: CGSize(width: 299, height: 299))
            
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
            imgCountCurrent += 1
            
        } catch {
        }
        
        // Do the honey caluclation when all images are classified
        if imgCountCurrent + 1 == predictionUIImages.count{
            HoneyCalculation()
        }
    }
    
    // Function for calculating the honey amount based on
    func HoneyCalculation(){
        let honeyPercent: Float = Float(honeyCount) / Float(predictionUIImages.count)
        
        let honeyLBPerSquareIn: Float = 0.033
        honeyTotal += (Float(dimWidth * dimHeight) * honeyPercent * honeyLBPerSquareIn)

        // Start the transistion to the next state
        done = true
        
        //Dismiss the view
        self.presentation.wrappedValue.dismiss()
    }
}

// Struct UIView for connecting the Mantis Cropping view to SwiftUI
struct ImageEditor: UIViewControllerRepresentable{
    typealias Coordinator = ImageEditorCoordinator

    // Binding variables for the image being cropped and
    // if the cropping view is showing.
    @Binding var theImage: UIImage?
    @Binding var isShowing: Bool

    func makeCoordinator() -> ImageEditorCoordinator {
        return ImageEditorCoordinator(image: $theImage, isShowing: $isShowing)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageEditor>) -> Mantis.CropViewController {
        let Editor = Mantis.cropViewController(image: theImage!)
        Editor.delegate = context.coordinator
        return Editor
    }
}

// ImageEditor Coordinator setup for using the Mantis Cropping View
class ImageEditorCoordinator: NSObject, CropViewControllerDelegate{
    
    // Binding variables for the image being cropped and
    // if the cropping view is showing.
    @Binding var theImage: UIImage?
    @Binding var isShowing: Bool

    init(image: Binding<UIImage?>, isShowing: Binding<Bool>){
        _theImage = image
        _isShowing = isShowing
    }

    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
        theImage = cropped
        isShowing = false
    }

    func cropViewControllerDidFailToCrop(_ cropViewController: CropViewController, original: UIImage) { print("ERROR: Failed to crop") }

    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) { isShowing = false }

    func cropViewControllerDidBeginResize(_ cropViewController: CropViewController){}

    func cropViewControllerDidEndResize(_ cropViewController: CropViewController, original: UIImage, cropInfo: CropInfo) {}

    func cropViewControllerWillDismiss(_ cropViewController: CropViewController) {}
}
