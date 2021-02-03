//
//  HiveCreator.swift
//  Honey Aggregator
//
//  Screen for editing a hive and adding bee boxes
//

import SwiftUI

struct HiveCreator: View {
    
    // State variable for holding hive name
    @State private var tempHiveName = ""
    
    // Enviorment variable for handeling navigation
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
            VStack{
                
                // Title for view
                Text("Hive Creator")
                    .font(.title)
                    .bold()
                
                // Dividers add a line to help seperate elements
                Divider()
                
                // Hstack for the showing and getting hive name
                HStack{
                    Text("Hive Name:")
                        .padding()
                    Spacer()
                    TextField("Hive Name", text: $tempHiveName)
                        .padding(.all)
                }
                
                Spacer()
                
                // List shows each of the boxes in the hive
                // Currently just gives a default box for now
                List(hives[0].beeBoxes) { box in
                        BoxListRow(box: box)
                }
                
                Divider()
                
                // Hstack for buttons at bottom of screen
                HStack{
                    
                    // Navigation link that sends user to FrameCreator View
                    // at this time.
                    NavigationLink(destination: FrameCreator()){
                        Text("Add Box")
                            .foregroundColor(.blue)
                    }.buttonStyle(PlainButtonStyle())
                    
                    // Button that saves the hive to the model data
                    // Currently just saves a empty hive with the name provided above
                    Button("Save"){
                        if (tempHiveName != ""){
                            let newHive = Hive(id: 3, hiveName: tempHiveName, honeyTotal: 0.0, beeBoxes: [])
                            save(filename:"hiveData.json", newHive: newHive)
                            self.presentation.wrappedValue.dismiss()
                        }
                    }
                }
            }

    }
}

struct HiveCreator_Previews: PreviewProvider {
    static var previews: some View {
        HiveCreator()
    }
}

// save function encodes the hive information and saves it to
// a JSON file. Currently has no way to overwrite existing hives.
func save(filename: String, newHive: Hive){
    
    hives.append(newHive)
    
    do {
        let encoder = JSONEncoder()
        let data = try encoder.encode(hives)
        if let file = FileHandle(forWritingAtPath:filename) {
            file.write(data)
        }
    } catch {
        fatalError("Couldn't save data to \(filename)")
    }
}
