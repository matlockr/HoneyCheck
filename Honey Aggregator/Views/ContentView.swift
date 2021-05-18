//
//  ContentView.swift
//  Honey Aggregator
//
//  Main Screen of the app
//

import SwiftUI

struct ContentView: View {

    // Singleton object that holds list of hives
    @EnvironmentObject var hives:Hives
    
    // Varible to hold menu button and default values
    @State private var menu = 0
    // Could not get this to work without the magic number Maybe someone else can?
    
    var body: some View {
        
        NavigationView{
            // The new functional part of this is that the menu picker will allow the user to see all saved hives and display the data based off of one of those selections.
            VStack {
                Picker("Hive Selection", selection: $menu) {
                    ForEach(0..<hives.menuArray.count, id: \.self) { index in
                        Text("\(1+index): " + hives.menuArray[index])
                    }
                }
                .foregroundColor(Color.orange)
                .padding(10)
                .background(Color(red: 255/255, green: 248/255, blue: 235/255))
                .cornerRadius(10)
                .font(.system(size: 20, weight: .heavy))
                .pickerStyle(MenuPickerStyle())
                
                Divider()
                
                Text(hives.menuSelect(index: menu))
                
                Spacer()
            }
            .navigationBarItems(leading: Text("HoneyCheck").foregroundColor(.orange)
)
            // Toolbar setup for the navigation buttons on the top of the view
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    // Navigation link to the FrameCreator view
                    NavigationLink(destination: FrameCreator().environmentObject(hives)){
                        Image(systemName: "plus")
                            .imageScale(.large)

                    }
                    
                    // Navigation Link to the SettingsMenu view
                    NavigationLink(destination: SettingsMenu().environmentObject(hives)){
                        Image(systemName: "gearshape.fill")
                            .imageScale(.large)
                    }
                }
            }
        }
        .onAppear(perform: {
            // Get the readout the first time to setup the readout string
            hives.readOut = hives.getReadOut()
            // Append the array of hives to the hive menu.
            hives.menuArray = hives.menuReadArray()
        
        })
        .accentColor(Color.orange)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Hives())
    }
}

