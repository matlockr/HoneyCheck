import SwiftUI

struct MakeArchive: View {
    @EnvironmentObject var hives:Hives
    
    @Environment(\.presentationMode) var presentationMode
    
    // Information for the views archive data
    @State var seasonName: String
    @State var warning: String
    
    var body: some View {
        VStack( content: {
            Text("Start New Season")
                .foregroundColor(Color.orange)
                .font(.system(size: 20, weight: .heavy))
                .padding()
            
            Divider()
            Spacer()
            
            Text("Do you want to archive the season?  You can't edit it once it is archived.")
                .fontWeight(.semibold)
                .padding()
                .font(.system(size: 20))
            Spacer()
            
            HStack{
                TextField("Name this season", text: $seasonName)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 255/255, green: 248/255, blue: 235/255)))
            }.padding(.horizontal)
            
            HStack {
                // Button for the starting archive process
                Button(action: {
                    let check = hives.archive(file: "\(seasonName).json")
                    if check == "Season was successfully archived!"{
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    else{
                        warning = check
                    }
                }){
                    Text("Archive")
                        .foregroundColor(Color.orange)
                        .padding(10)
                        .background(Color(red: 255/255, green: 248/255, blue: 235/255))
                        .cornerRadius(10)
                        .font(.system(size: 20, weight: .heavy))
                }.padding()
                .disabled(seasonName.isEmpty)
                
                if(warning.isEmpty){
                    Text("\(warning)").hidden()
                }
                else{
                    Text("\(warning)").padding()
                }
                
                // Button for canceling archive
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Text("Cancel")
                        .foregroundColor(Color.orange)
                        .padding(10)
                        .background(Color(red: 255/255, green: 248/255, blue: 235/255))
                        .cornerRadius(10)
                        .font(.system(size: 20, weight: .heavy))
                }.padding()
                    
            }
        })
    }
}
