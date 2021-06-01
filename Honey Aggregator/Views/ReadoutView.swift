import SwiftUI

struct ReadoutView: View {
    
    // Singleton object that holds list of hives
    @EnvironmentObject var hives:Hives
    
    // Holds the index for what hive should be showing on the read out
    var menuIndex: Int
    
    var body: some View {
        VStack{
            if hives.menuIndexValid(idx: menuIndex){
                if hives.isMetric{
                    HStack {
                        Text("Hive: \(hives.hiveList[menuIndex].hiveName)")
                            .padding(.leading)
                            .font(.system(size: 24))
                        Spacer()
                        Text("\(String(format: "%.2f", hives.getHiveHoneyTotal(hiveidx: menuIndex) / 2.20)) kg")
                            .padding(.trailing)
                            .font(.system(size: 24))
                    }.background(Color(red: 255/255, green: 194/255, blue: 82/255))
                    ForEach(hives.hiveList[menuIndex].beeBoxes){ box in
                        HStack{
                            Text("Box: \(box.idx + 1)")
                                .padding(.leading)
                                .font(.system(size: 20))
                            Spacer()
                            Text("\(String(format: "%.2f", hives.getBoxHoneyAmount(hiveidx: menuIndex, boxidx: box.idx) / 2.20)) kg")
                                .padding(.trailing)
                                .font(.system(size: 20))
                        }.background(Color(red: 255/255, green: 218/255, blue: 148/255))
                        ForEach(box.frames){ frame in
                            HStack{
                                Text("Frame: \(frame.idx + 1) ")
                                    .padding(.leading)
                                    .font(.system(size: 16))
                                Spacer()
                                Text("\(String(format: "%.2f", (frame.honeyTotalSideA + frame.honeyTotalSideB) / 2.20)) kg")
                                    .padding(.trailing)
                                    .font(.system(size: 16))
                            }.background(Color(red: 255/255, green: 235/255, blue: 201/255))
                        }
                    }
                } else {
                    HStack{
                        Text("Hive: \(hives.hiveList[menuIndex].hiveName)")
                            .padding(.leading)
                            .font(.system(size: 24))
                        Spacer()
                        Text("\(String(format: "%.2f", hives.getHiveHoneyTotal(hiveidx: menuIndex))) lbs")
                            .padding(.trailing)
                            .font(.system(size: 24))
                    }.background(Color(red: 255/255, green: 194/255, blue: 82/255))
                    ForEach(hives.hiveList[menuIndex].beeBoxes){ box in
                        HStack{
                            Text("Box: \(box.idx + 1)")
                                .padding(.leading)
                                .font(.system(size: 20))
                            Spacer()
                            Text("\(String(format: "%.2f", hives.getBoxHoneyAmount(hiveidx: menuIndex, boxidx: box.idx))) lbs")
                                .padding(.trailing)
                                .font(.system(size: 20))
                        }.background(Color(red: 255/255, green: 218/255, blue: 148/255))
                        ForEach(box.frames){ frame in
                            HStack{
                                Text("Frame: \(frame.idx + 1) ")
                                    .padding(.leading)
                                    .font(.system(size: 16))
                                Spacer()
                                Text("\(String(format: "%.2f", frame.honeyTotalSideA + frame.honeyTotalSideB)) lbs")
                                    .padding(.trailing)
                                    .font(.system(size: 16))
                            }.background(Color(red: 255/255, green: 235/255, blue: 201/255))
                        }
                    }
                }
            }
        }
    }
}
