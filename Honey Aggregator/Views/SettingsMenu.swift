//
//  SettingsMenu.swift
//  Honey_Agg
//
//  Created by Robert Matlock on 3/20/21.
//  Special thanks to Paul Hudson
//   https://www.hackingwithswift.com/quick-start/swiftui/enabling-and-disabling-elements-in-forms
//  Special thanks to Andrew Jackson
//  https://medium.com/@codechimp_org/implementing-multiple-action-sheets-from-toolbar-buttons-with-swiftui-ce3bce2b97cb
import SwiftUI
import UniformTypeIdentifiers

struct SettingsMenu: View {
    //The enum is used to create multiple action sheets
    enum Sheets: Identifiable {
            case reset, archiveMake

            var id: Int {
                self.hashValue
            }
        }
    //activeSheet is used to add child sheets
    @State var activeSheet: Sheets?
    // Singleton object that holds list of hives
    @EnvironmentObject var hives:Hives
    @State private var showingActionSheet = false
    
    // This is just used for being able to dissmiss the view in code
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isDrawingPictureHandler: Bool = false
    @State private var isMetric:Bool = false
    
    @State private var showExportSheet: Bool = false
    @State private var csvHead: String = ""
    @State private var document = TextFile()
    
    var body: some View {
        VStack{

            Toggle("Use Metric", isOn: $isMetric)
                .onChange(of: isMetric) {value in
                    hives.isMetric = isMetric
                    hives.readOut = hives.getReadOut()
                }
                .padding()
        
            Toggle("Drawing Feature", isOn: $isDrawingPictureHandler)
                .onChange(of: isDrawingPictureHandler) {value in
                    hives.isDrawingHandler = isDrawingPictureHandler
                }
                .padding()
            
            Spacer()
            
            Divider()
            
            //Start new season button
            Button(action: {
                print("Start New Season Clicked")
                self.activeSheet = .archiveMake
            }){
                Text("Start New Season")
            }
            
            List{
                Text("2020")
                Text("2018")
                Text("2019")
            }
            
            Button(action: {
                csvHead = "Season,Date,Hive Title,Box #,Frame Area,Frame #,Side,Honey Weight Estimate\n"
                
                
                for i in 0..<hives.hiveList.count{
                    for j in 0..<hives.hiveList[i].beeBoxes.count{
                        for frame in hives.hiveList[i].beeBoxes[j].frames{
                            csvHead.append("2021,\(frame.dateMade),\(hives.hiveList[i].hiveName),\(hives.hiveList[i].beeBoxes[j].idx),\(frame.width * frame.height),\(frame.idx),A,\(frame.honeyTotalSideA)\n")
                            csvHead.append("2021,\(frame.dateMade),\(hives.hiveList[i].hiveName),\(hives.hiveList[i].beeBoxes[j].idx),\(frame.width * frame.height),\(frame.idx),B,\(frame.honeyTotalSideB)\n")
                        }
                    }
                }
                
                document.text = csvHead
                showExportSheet = true
            }){
                Text("Export Data")
            }
            .padding(.bottom)
            
            Button(action: {
                self.showingActionSheet = true
                self.activeSheet = .reset
                //self.showingActionSheet = true
                // Dismiss the view and return to the ContentView view
                //presentationMode.wrappedValue.dismiss()
            }){
                Text("Clear Current Hives")
            }.frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }            .padding(.bottom)
        }
        .fileExporter(isPresented: $showExportSheet, document: document, contentType: UTType.commaSeparatedText){ result in
            switch result {
            case .success(let url):
                print("Saved to \(url)")
            case .failure(let error):
                print(error.localizedDescription)
          }
        .sheet(item: $activeSheet, onDismiss: { activeSheet = nil }) { item in
          switch item {
          case .reset:
              ResetHives()
          case .archiveMake:
              MakeArchive(seasonName: "", warning: "")
          }
        }
        /*.navigationBarItems(leading: Text("Honey Aggregator")).actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("Clear Hive Data"), buttons: [
                .default(Text("Confirm Reset?")) { hives.reset() },
                 .cancel()
                    ]
                )
            }
            }*/
    .onAppear(perform: {
          isMetric = hives.isMetric
          isDrawingPictureHandler = hives.isDrawingHandler
      })
    
}

struct SettingsMenu_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMenu().environmentObject(Hives())
    }
}

struct TextFile: FileDocument {
    // tell the system we support only plain text
    static var readableContentTypes = [UTType.commaSeparatedText]

    // by default our document is empty
    var text = ""

    // a simple initializer that creates new, empty documents
    init(initialText: String = "") {
        text = initialText
    }

    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        }
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}
