//
//  ImageDrawer.swift
//  Honey Aggregator
//
//  This file handles that basic version of the image processing using the
//  the PencilKit and SwiftImage Frameworks
//  The PencilKit setup was done with help by this tutorial: https://www.raywenderlich.com/12198216-drawing-with-pencilkit-getting-started

import SwiftUI
import PencilKit
import SwiftImage

struct ImageDrawer: View {
    
    // This is just used for being able to dissmiss the view in code
    @Environment(\.presentationMode) var presentationMode
    
    // Image variables
    var backgroundImage: UIImage?
    @State private var currentbackgroundImage: UIImage?
    @State private var originalImage: UIImage?
    
    // connects the prior view's honeyPercent
    @Binding var honeyPercent: Float
    
    // PencilKit canvas object
    @State var canvas = PKCanvasView()
    
    // UI variables
    @State var instructionText = "Crop the image to just the frame"
    @State var buttonText = "Next"
    
    // State of where image process it at
    @State var honeyDrawingState = false
    
    // Main crop variables based on stepper input
    @State var widthCrop = 0
    @State var heightCrop = 0
    
    
    // Bounding Box varibles for cropping
    @State var cropBoxWidth: CGFloat = 0
    @State var cropBoxHeight: CGFloat = 0
    @State var originalBoxWidth: CGFloat = 0
    @State var originalBoxHeight: CGFloat = 0
    
            
    var body: some View{
        NavigationView{
            
            VStack{
                
                // Sets the instruction text UI for providing user information
                Text(instructionText)
                    .padding()
                    .font(.title2)
                
                if honeyDrawingState == false{
                    
                    // Stepper for the width property
                    Stepper("Width Crop: ", onIncrement: {
                        if widthCrop < 100{
                            widthCrop += 1
                            cropBoxWidth = originalBoxWidth * CGFloat(100 - widthCrop * 2) / 100
                        }
                    }, onDecrement: {
                        if widthCrop > 0{
                            widthCrop -= 1
                            cropBoxWidth = originalBoxWidth * CGFloat(100 - widthCrop * 2) / 100
                        }
                    }).padding()
                    
                    // Stepper for the height property
                    Stepper("Height Crop: ", onIncrement: {
                        if heightCrop < 100{
                            heightCrop += 1
                            cropBoxHeight = originalBoxHeight * CGFloat(100 - heightCrop * 2) / 100
                        }
                    }, onDecrement: {
                        if heightCrop > 0{
                            heightCrop -= 1
                            cropBoxHeight = originalBoxHeight * CGFloat(100 - heightCrop * 2) / 100
                        }
                    }).padding()
                }
                
                Spacer()
                
                //This ZStack has a bas of the image, next layer is either the Drawing view or the bounding box used for cropping
                ZStack{
                    if currentbackgroundImage != nil{
                        Image(uiImage: currentbackgroundImage!)
                            .resizable()
                            .frame(width: currentbackgroundImage?.size.width, height: currentbackgroundImage?.size.height, alignment: .center)
                    }
                    
                    if honeyDrawingState {
                        DrawingView(canvas: $canvas)
                            .frame(width: currentbackgroundImage?.size.width, height: currentbackgroundImage?.size.height, alignment: .center)
                    }
                    
                    if !honeyDrawingState{
                        Rectangle()
                            .foregroundColor(Color.clear)
                            .frame(width: cropBoxWidth, height: cropBoxHeight, alignment: .center)
                            .border(Color.orange, width: 3)
                    }
                }
                
                Spacer()
                Divider()
                
                HStack{
                    // This button changes it use despending on what state the image proccessing is in. The first state handles the image cropping and second state handles calculating the honey percentage.
                    Button(action: {
                        if honeyDrawingState{
                            
                            // Get a screenshot of the current view
                            var image: UIImage?
                            let currentLayer = UIApplication.shared.keyWindow!.layer
                            let currentScale = UIScreen.main.scale
                            UIGraphicsBeginImageContextWithOptions(currentLayer.frame.size, false, currentScale)
                            guard let currentContext = UIGraphicsGetCurrentContext() else {return}
                            currentLayer.render(in: currentContext)
                            image = UIGraphicsGetImageFromCurrentImageContext()
                            UIGraphicsEndImageContext()

                            
                            // Convert that screenshot into SwiftImage Image type
                            let imageTest = SwiftImage.Image<RGBA<UInt8>>(uiImage: image!)
                            var bluePixels: Int = 0
                            
                            // Go through each pixel of imageTest to see if the pixel is same color as drawing color
                            for x in 0..<imageTest.width{
                                for y in 0..<imageTest.height{
                                    let pixel: String = imageTest[x, y].description
                                    if (pixel == "#0000FFFF"){
                                        bluePixels += 1
                                    }
                                }
                            }
                            
                            // Get pixel count of cropped image
                            let framePixels = Int((currentbackgroundImage?.size.width)! * (currentbackgroundImage?.size.height)!) * 4
                            
                            // Calculate the honey percentage
                            if framePixels > 0 && bluePixels > 0{
                                if framePixels > bluePixels{
                                    honeyPercent = Float(bluePixels) / Float(framePixels)
                                } else {
                                    honeyPercent = 1.0
                                }
                            }
                            
                            // Dismiss the view and return to FrameCreator
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            
                            // If not in honey drawing state then crop the image and change UI elemnts states and properties
                            cropImage()
                            honeyDrawingState = true
                            instructionText = "Draw over where there is honey"
                            buttonText = "Done"
                        }
                    }){
                        Text(buttonText)
                    }.padding(.bottom)
                    .padding(.top)
                }
            }
        }
        .onAppear{
            
            // Since the image is too large, we need to resize the image and then make a copy of it for when we are cropping
            if backgroundImage != nil{
                originalImage = backgroundImage
                let image = SwiftImage.Image<RGBA<UInt8>>(uiImage: originalImage!)
                originalImage = image.resizedTo(width: Int(Double(image.width) * 0.1), height: Int(Double(image.height) * 0.1)).uiImage
                currentbackgroundImage = originalImage
                originalBoxWidth = (currentbackgroundImage?.size.width)!
                originalBoxHeight = (currentbackgroundImage?.size.height)!
                cropBoxWidth = originalBoxWidth
                cropBoxHeight = originalBoxHeight
            }
        }
    }
    
    // This function takes the crop values of widthCrop and heightCrop and applies there values to crop the image on the screen
    func cropImage(){
        if backgroundImage != nil{
            let croppingImage = SwiftImage.Image<RGBA<UInt8>>(uiImage: originalImage!)
            let height = croppingImage.height
            let width = croppingImage.width
            
            let bottomXRange = Int(Double(width) * Double(widthCrop) * 0.01)
            let topXRange = Int(Double(width) * Double(100 - widthCrop) * 0.01)
            let bottomYRange = Int(Double(height) * Double(heightCrop) * 0.01)
            let topYRange = Int(Double(height) * Double(100 - heightCrop) * 0.01)
            
            let xRange = bottomXRange..<topXRange
            let yRange = bottomYRange..<topYRange
            
            let slice: ImageSlice<RGBA<UInt8>> = croppingImage[xRange, yRange]
            let cropped = SwiftImage.Image<RGBA<UInt8>>(slice)
            currentbackgroundImage = cropped.uiImage
            
        }
    }
}

// This struct if for handling the canvas view and its properties
struct DrawingView: UIViewRepresentable {
    
    @Binding var canvas: PKCanvasView
    @State var picker = PKToolPicker.init()
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        canvas.backgroundColor = .clear
        canvas.isOpaque = false
        canvas.tool = PKInkingTool(.pen, color: UIColor(red: 0.0, green: 0.0, blue: 255.0, alpha: 255.0), width: 50)
        canvas.becomeFirstResponder()
        return canvas
    }
    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
}
