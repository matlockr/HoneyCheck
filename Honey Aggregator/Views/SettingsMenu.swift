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
            case reset, archiveMake, about

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
    
    // State variables for the holding some ui viewing variables
    @State private var isDrawingPictureHandler: Bool = false
    @State private var isMetric:Bool = false
    @State private var showExportSheet: Bool = false
    
    // Setup for exporting the CSV
    @State private var csvHead: String = ""
    @State private var document = TextFile()
    
    var body: some View {
        VStack{
            // Toggle for using metric or not
            Toggle("Use Metric", isOn: $isMetric)
                .onChange(of: isMetric) {value in
                    hives.isMetric = isMetric
                    hives.readOut = hives.getReadOut()
                }
                .foregroundColor(Color.orange)
                .font(.system(size: 20, weight: .heavy))
                .padding(.horizontal)
        
            // Toggle for using the drawing feature or not
            Toggle("Drawing Feature", isOn: $isDrawingPictureHandler)
                .onChange(of: isDrawingPictureHandler) {value in
                    hives.isDrawingHandler = isDrawingPictureHandler
                }
                .foregroundColor(Color.orange)
                .font(.system(size: 20, weight: .heavy))
                .padding()
            
            
            Divider()
            Spacer()

            
            // Export CSV Button
            Button(action: {
                exportCSV()
            }){
                Text("Export Data")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .foregroundColor(Color.orange)
                    .padding(10)
                    .background(Color(red: 255/255, green: 248/255, blue: 235/255))
                    .cornerRadius(10)
                    .font(.system(size: 20, weight: .heavy))
            }.buttonStyle(PlainButtonStyle())
            .padding(.horizontal)
                  
            // Clear the current hives information button
            Button(action: {
                self.showingActionSheet = true
                self.activeSheet = .reset
            }){
                Text("Clear Current Hives")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .foregroundColor(Color.orange)
                    .padding(10)
                    .background(Color(red: 255/255, green: 248/255, blue: 235/255))
                    .cornerRadius(10)
                    .font(.system(size: 20, weight: .heavy))
            }
            .padding(.bottom)
            .padding(.horizontal)
        }
        
        // Button to show the about us sheet
        Button(action: {
            self.showingActionSheet = true
            self.activeSheet = .about
        }){
            Text("About Us")
                .frame(minWidth: 0, maxWidth: .infinity)
                .foregroundColor(Color.orange)
                .padding(10)
                .background(Color(red: 255/255, green: 248/255, blue: 235/255))
                .font(.system(size: 15, weight: .heavy))
        }
        .fileExporter(isPresented: $showExportSheet, document: document, contentType: UTType.commaSeparatedText){ result in
            switch result {
            case .success(let url):
                print("Saved to \(url)")
            case .failure(let error):
                print(error.localizedDescription)
          }
        }
        .sheet(item: $activeSheet, onDismiss: { activeSheet = nil }) { item in
          switch item {
          case .reset:
            ResetHives()
          case .archiveMake:
            MakeArchive(seasonName: "", warning: "")
          case .about:
            Text("Swipe down to dismiss")
              .padding(.top)
              .font(.system(size: 12, weight: .light))
            Divider()
            Text("HoneyCheck is an application developed to help local beekeepers in the Southern Oregon area.\n\nIt was designed by a group of Computer Science capstone students based out of Southern Oregon University.\n ")
                .padding(.top)
                .padding(.horizontal)
                .font(.system(size:14, weight: .light))
            
            VStack(alignment: .leading) {
                Text("HoneyCheck was created by: \n\n\tRobert Matlock \n\tNicholas Morales \n\tCollin Robinson \n\tAvery Economou \n\nFaculty Supervisor:\n\n\tFabrizzio Soares ")
                  .padding(10)
                  .multilineTextAlignment(.leading)
                  .font(.system(size:14, weight: .heavy))
            }
            Divider()
            Text("Application is owned by and maintained by RaiderSoft and the Southern Oregon University IT Department. \n ")
                .italic()
                .font(.system(size: 12, weight: .light))
          }
        }
        .onAppear(perform: {
              isMetric = hives.isMetric
              isDrawingPictureHandler = hives.isDrawingHandler
          })
    }
    
    // Setup the CSV string information for the export
    func exportCSV(){
        csvHead = "Date,Hive Title,Box #,Frame Area,Frame #,Side,Honey Weight Estimate\n"
        
        for i in 0..<hives.hiveList.count{
            for j in 0..<hives.hiveList[i].beeBoxes.count{
                for frame in hives.hiveList[i].beeBoxes[j].frames{
                    csvHead.append("\(frame.dateMade),\(hives.hiveList[i].hiveName),\(hives.hiveList[i].beeBoxes[j].idx + 1),\(frame.width * frame.height),\(frame.idx + 1),A,\(frame.honeyTotalSideA)\n")
                    csvHead.append("\(frame.dateMade),\(hives.hiveList[i].hiveName),\(hives.hiveList[i].beeBoxes[j].idx + 1),\(frame.width * frame.height),\(frame.idx + 1),B,\(frame.honeyTotalSideB)\n")
                }
            }
        }
        document.text = csvHead
        showExportSheet = true
    }
}

struct TextFile: FileDocument {
    // Setup file export to be a CSV file
    static var readableContentTypes = [UTType.commaSeparatedText]

    // Text for the document
    var text = ""

    // Create an empty document
    init(initialText: String = "") {
        text = initialText
    }

    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        }
    }

    // Used to tell system to write to storage
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}
