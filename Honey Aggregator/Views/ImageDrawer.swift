//
//  ImageDrawer.swift
//  Honey Aggregator
//
//  Created by Robert Matlock on 2/23/21.
//

import SwiftUI
import PencilKit
import SwiftImage

struct ImageDrawer: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var backgroundImage: UIImage?
    @State private var currentbackgroundImage: UIImage?
    @State private var originalImage: UIImage?
    
    @Binding var honeyPercent: Float
    
    @State var canvas = PKCanvasView()
        
    @State var bluePixels = 0
        
    @State var instructionText = "Crop the image to just the frame"
    @State var buttonText = "Next"
    @State var honeyDrawingState = false
    
    @State var widthCrop = 0
    @State var heightCrop = 0
    
            
    var body: some View{
        NavigationView{
            VStack{
                if honeyDrawingState == false{
                    Stepper("Width Crop: ", onIncrement: {
                        if widthCrop < 100{
                            widthCrop += 1
                            cropImage()
                        }
                    }, onDecrement: {
                        if widthCrop > 0{
                            widthCrop -= 1
                            cropImage()
                        }
                    })
                    Stepper("Height Crop: ", onIncrement: {
                        if heightCrop < 100{
                            heightCrop += 1
                            cropImage()
                        }
                    }, onDecrement: {
                        if heightCrop > 0{
                            heightCrop -= 1
                            cropImage()
                        }
                    })
                }
                
                Text(instructionText)
                    .padding()
                    .font(.title2)
                Spacer()
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
                }
                Spacer()
                Divider()
                HStack{
                    Button(action: {
                        if honeyDrawingState{
                            var image: UIImage?
                                
                            let currentLayer = UIApplication.shared.keyWindow!.layer
                                
                            let currentScale = UIScreen.main.scale
                                
                            UIGraphicsBeginImageContextWithOptions(currentLayer.frame.size, false, currentScale)
                                
                            guard let currentContext = UIGraphicsGetCurrentContext() else {return}
                                
                            currentLayer.render(in: currentContext)
                                
                            image = UIGraphicsGetImageFromCurrentImageContext()
                                
                            UIGraphicsEndImageContext()

                            let imageTest = SwiftImage.Image<RGBA<UInt8>>(uiImage: image!)
                                
                            for x in 0..<imageTest.width{
                                for y in 0..<imageTest.height{
                                    let pixel: String = imageTest[x, y].description
                                    if (pixel == "#0000FFFF"){
                                        bluePixels += 1
                                    }
                                }
                            }
                                
                            let framePixels = Int((currentbackgroundImage?.size.width)! * (currentbackgroundImage?.size.height)!) * 4
                            if framePixels > 0 && bluePixels > 0{
                                if framePixels > bluePixels{
                                    honeyPercent = Float(bluePixels) / Float(framePixels)
                                } else {
                                    honeyPercent = 1.0
                                }
                            }
                            
                            print(framePixels)
                            print(bluePixels)
                            print(honeyPercent)
                            
                            canvas.drawing = PKDrawing()
                            presentationMode.wrappedValue.dismiss()
                        } else {
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
            if backgroundImage != nil{
                originalImage = backgroundImage
                let image = SwiftImage.Image<RGBA<UInt8>>(uiImage: originalImage!)
                originalImage = image.resizedTo(width: Int(Double(image.width) * 0.1), height: Int(Double(image.height) * 0.1)).uiImage
                currentbackgroundImage = originalImage

            }
        }
    }
    
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

struct ImageDrawer_Previews: PreviewProvider {
    static var previews: some View {
        ImageDrawer(backgroundImage: nil, honeyPercent: .constant(0.0))
    }
}

struct DrawingView: UIViewRepresentable {
    
    @Binding var canvas: PKCanvasView
    
    @State var picker = PKToolPicker.init()
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        canvas.backgroundColor = .clear
        canvas.isOpaque = false
        
        canvas.tool = PKInkingTool(.pen, color: UIColor(red: 0.0, green: 0.0, blue: 255.0, alpha: 255.0), width: 50)
        
        
        
        //picker.setVisible(true, forFirstResponder: canvas)
        //picker.addObserver(canvas)
        canvas.becomeFirstResponder()
        
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
    }
    
}
