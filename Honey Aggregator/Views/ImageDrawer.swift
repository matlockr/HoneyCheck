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
    
    var backgroundImage: SwiftUI.Image?
    
    @Binding var honeyPercent: Float
    
    @State var canvas = PKCanvasView()
        
    @State var redPixels = 0
    @State var bluePixels = 0
        
    @State var instructionText = "Draw over the whole frame"
    @State var buttonText = "Next"
    @State var honeyDrawingState = false
            
    var body: some View{
        NavigationView{
            VStack{
                Text(instructionText)
                    .padding()
                    .font(.title2)
                ZStack{
                    backgroundImage?
                        .resizable()
                        .scaledToFit()
                    DrawingView(canvas: $canvas)
                }
                Divider()
                HStack{
                    Button(action: {
                        var image: UIImage?
                            
                        let currentLayer = UIApplication.shared.keyWindow!.layer
                            
                        let currentScale = UIScreen.main.scale
                            
                        UIGraphicsBeginImageContextWithOptions(currentLayer.frame.size, false, currentScale)
                            
                        guard let currentContext = UIGraphicsGetCurrentContext() else {return}
                            
                        currentLayer.render(in: currentContext)
                            
                        image = UIGraphicsGetImageFromCurrentImageContext()
                            
                        UIGraphicsEndImageContext()

                        let imageTest = SwiftImage.Image<RGBA<UInt8>>(uiImage: image!) // from a UIImage
                            
                        for x in 0..<imageTest.width{
                            for y in 0..<imageTest.height{
                                let pixel: String = imageTest[x, y].description
                                if honeyDrawingState == false{
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
                            
                        
                        if redPixels > 0 && bluePixels > 0{
                            if redPixels > bluePixels{
                                honeyPercent = Float(bluePixels) / Float(redPixels)
                            } else {
                                honeyPercent = 1.0
                            }
                        }
                                                        
                        canvas.drawing = PKDrawing()
                        
                        if honeyDrawingState == false{
                            honeyDrawingState = true
                            instructionText = "Draw over where there is honey"
                            buttonText = "Done"
                            
                            canvas.tool = PKInkingTool(.pen, color: UIColor(red: 0.0, green: 0.0, blue: 255.0, alpha: 255.0), width: 50)
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }){
                        Text(buttonText)
                    }.padding(.bottom)
                    .padding(.top)
                }
            }
        }
    }
}

struct ImageDrawer_Previews: PreviewProvider {
    static var previews: some View {
        ImageDrawer(backgroundImage: Image("comb"), honeyPercent: .constant(0.0))
    }
}

struct DrawingView: UIViewRepresentable {
    
    @Binding var canvas: PKCanvasView
    
    @State var picker = PKToolPicker.init()
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        canvas.backgroundColor = .clear
        canvas.isOpaque = false
        
        canvas.tool = PKInkingTool(.pen, color: UIColor(red: 255.0, green: 0.0, blue: 0.0, alpha: 255.0), width: 50)
        
        
        
        //picker.setVisible(true, forFirstResponder: canvas)
        //picker.addObserver(canvas)
        canvas.becomeFirstResponder()
        
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
    }
    
}
