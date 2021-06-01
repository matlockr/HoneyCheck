import SwiftUI

struct ResetHives: View {
    @EnvironmentObject var hives:Hives
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 20, content: {
            
            Text("Confirm Reset?")
                .foregroundColor(Color.orange)
                .font(.system(size: 20, weight: .heavy))
                .padding()
            HStack{
                // Button for doing the reset
                Button(action: {
                    hives.reset()
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Text("Reset")
                        .foregroundColor(Color.orange)
                        .padding(10)
                        .background(Color(red: 255/255, green: 248/255, blue: 235/255))
                        .cornerRadius(10)
                        .font(.system(size: 20, weight: .heavy))
                        .pickerStyle(MenuPickerStyle())
                }.padding()

                // Button for canceling the reset
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Text("Cancel")
                        .foregroundColor(Color.orange)
                        .padding(10)
                        .background(Color(red: 255/255, green: 248/255, blue: 235/255))
                        .cornerRadius(10)
                        .font(.system(size: 20, weight: .heavy))
                        .pickerStyle(MenuPickerStyle())
                }.padding()
            }
        })
    }
}
