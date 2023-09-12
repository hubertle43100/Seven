//
//  ContentView.swift
//  TinyHabits
//
//  Created by Hubert Le on 7/7/22.
//

import SwiftUI
import EventKit

struct ContentView: View {
    @State private var selectedDayIndex = 0
    @State private var currentDayIndex = 0
    @State var storedTexts = UserDefaults.standard.array(forKey: "receivedStoredTexts") as? [String]
    @State private var messageTemp = UserDefaults.standard.string(forKey: "messageTemp") ?? ""
    @State private var isPresentingPopupSheet = false
    @State private var currentDayArray = UserDefaults.standard.array(forKey: "NextSevenDays")
    @State var refresh: Bool = false
    let dateFormatter = DateFormatter()
    @State var isTaskGenerated = true
    
    
    var body: some View {
        ZStack {
            VStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 433, height: 200)
                    .background(Color.green.opacity(0.2))
                Spacer()
            }.onAppear {
                testFunction()
            }
            DateHeaderView(selectedDayIndex:  $selectedDayIndex)
            
            if isTaskGenerated {
                GetStartedView(isGenerated: $isTaskGenerated)
            } else {
                taskDisplayView(selectedDayIndex:  $selectedDayIndex, currentDayIndex: $currentDayIndex, isGenerated: $isTaskGenerated)
            }
            
        }.onChange(of: messageTemp) { newValue in
            UserDefaults.standard.set(newValue, forKey: "messageTemp")
        }
    }
    func testFunction() {
        let date = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Format to get the numeric date (e.g., 01, 02, 03)
        let formattedDate = dateFormatter.string(from: date)
        
        if let currentDayArray = currentDayArray as? [String] {
            if let index = currentDayArray.firstIndex(of: formattedDate) {
                currentDayIndex = index
            } else {
                print("Matching date not found in Array 2.")
                storedTexts = []
            }
        } else {
            print("Array 2 is nil.")
        }
    }
    
    func getDate(for index: Int) -> String {
        let date = Calendar.current.date(byAdding: .day, value: index, to: Date()) ?? Date()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Format to get the numeric date (e.g., 01, 02, 03)
        let formattedDate = dateFormatter.string(from: date)
        
        return formattedDate
    }
}
func getNext7Days() -> [Date] {
    var dates: [Date] = []
    var currentDate = Calendar.current.startOfDay(for: Date())
    for _ in 1...7 {
        dates.append(currentDate)
        currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
    }
    return dates
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct GetStartedView: View {
    @State private var isFullScreenPresented = false
    @State private var storedTexts: [String] = [] // New state variable to store the retrieved text
    @State private var messageTemp: String = ""
    @Binding var isGenerated: Bool
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 160, height: 96)
                    .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                    .cornerRadius(5)
                    .offset(x:45)
                HStack {
                    Text("Get\nStarted").font(.system(size: 24, weight: .medium, design: .default))
                        .rotationEffect(Angle(degrees: -90)).opacity(0.3)
                    Button("HERE") {
                        isFullScreenPresented = true
                    }.font(.system(size: 50, weight: .semibold, design: .default))
                        .foregroundColor(.black)
                        .fullScreenCover(isPresented: $isFullScreenPresented) {
                            GenerateGoalView(isFullScreenPresented: $isFullScreenPresented, onDismiss: { receivedStoredTexts,receivedMessageTemp  in
                                // This closure is called when generateGoals is dismissed,
                                // and it receives the storedTexts array back from generateGoals.
                                // You can handle the array here as needed.
                                print("Received storedTexts:", receivedStoredTexts)
                                storedTexts = receivedStoredTexts
                                messageTemp = receivedMessageTemp
                                let userDefaults = UserDefaults.standard
                                userDefaults.set(storedTexts, forKey: "receivedStoredTexts")
                                userDefaults.set(messageTemp, forKey: "messageTemp")
                                userDefaults.set([0,0,0,0,0,0,0], forKey: "booleanArray")
                                
                                saveNextSevenDaysToUserDefaults()
                                isGenerated.toggle()
                            })
                        }
                }
                
            }.offset(x:-20).padding()
            Divider().frame(width: 70).overlay(.gray).rotationEffect(Angle(degrees: -90)).padding(50)
            HStack {
                Image(systemName: "circle.fill").opacity(0.2)
                    .offset(x: 10)
                Text("Create a task for the next 7 days").frame(width: 262, height: 56, alignment: .center)
            }.foregroundColor(.black)
        }.offset(y:100)
    }
    func saveNextSevenDaysToUserDefaults() {
        let calendar = Calendar.current
        let date = Date()
        var datesArray: [String] = []
        
        for i in 0..<7 {
            if let nextDate = calendar.date(byAdding: .day, value: i, to: date) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateString = dateFormatter.string(from: nextDate)
                datesArray.append(dateString)
            }
        }
        print("COWARD: \(datesArray)")
        UserDefaults.standard.set(datesArray, forKey: "NextSevenDays")
    }
}


struct taskDisplayView: View {
    @State var messageTemp = UserDefaults.standard.string(forKey: "messageTemp") ?? ""
    @Binding var selectedDayIndex: Int
    @Binding var currentDayIndex: Int
    @Binding var isGenerated: Bool
    
    var body: some View {
        VStack {
            Text("\(messageTemp)")
                .font(.system(size: 24, weight: .bold))
            Divider()
                .padding()
            
            VStack {
                HStack {
                    Group {
                        if selectedDayIndex + currentDayIndex < 7 {
                            dailyCellView(selectedDayIndex: $selectedDayIndex, currentDayIndex: $currentDayIndex, messageTemp: messageTemp, isGenerated: $isGenerated).font(.system(size: 18, weight: .semibold))
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                        } else {
                            offDayview(currentDayIndex: $currentDayIndex)
                        }
                    }
                }
            }
            Spacer()
        }.frame(maxWidth: 375)
            .offset(y:250)
    }
    private func arrayToString(_ array: [Int]) -> String {
        return array.map(String.init).joined(separator: ", ")
    }
}

struct offDayview: View {
    @Binding var currentDayIndex: Int
    var body: some View {
        VStack{
            
            ZStack {
                Group {
                    Circle()
                        .fill(Color(.green).opacity(0.2))
                        .frame(width: 250, height: 250)
                    
                    Text("🤙")
                        .font(.system(size: 74, weight: .semibold))
                }.offset(x: 50, y: -120)
                
                
                HStack {
                    VStack {
                        Text("You Got\nThis!")
                            .font(.system(size: 40, weight: .bold))
                        Spacer()
                        Text("Almost there")
                            .font(.system(size: 20, weight: .regular))
                        
                        Text("\(7 - currentDayIndex) days left!")
                            .font(.system(size: 24, weight: .semibold))
                        Spacer()
                    }
                    Spacer()
                }.padding()
            }.offset(y: -40)
        }
    }
}

struct dailyCellView: View {
    @State var storedTexts = UserDefaults.standard.array(forKey: "receivedStoredTexts") as? [String]
    @State private var isPresentingPopupSheet = false
    @Binding var selectedDayIndex: Int
    @Binding var currentDayIndex: Int
    @State var isHoldingButton = UserDefaults.standard.bool(forKey: "holdingButton")
    @State var messageTemp: String
    @State private var booleanArray: [Int] = (UserDefaults.standard.array(forKey: "booleanArray") as? [Int] ?? [])
    @Binding var isGenerated: Bool
    
    private let blankArray: [String] = []
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    if selectedDayIndex + currentDayIndex < 7 {
                        Text(storedTexts?[selectedDayIndex + currentDayIndex] ?? "")
                        Spacer()
                    } else {
                        Text("Nothing here right now. Finish up the week's task first")
                        Spacer()
                    }
                }
                HStack {
                    Spacer()
                    Text("Hold for completion")
                        .font(.system(size: 14, weight: .semibold))
                        .opacity(0.5)
                        .padding(.top, 5)
                }
            }
            .padding()
            .background(booleanArray[currentDayIndex] == 0 || selectedDayIndex != 0 ? Color.gray.opacity(0.2) : Color.green.opacity(0.2))
            .cornerRadius(8)
            .onTapGesture {
                // This will present the sheet when the VStack is tapped
                isPresentingPopupSheet  = true
            }
            .gesture(selectedDayIndex + currentDayIndex == currentDayIndex ?
                     LongPressGesture(minimumDuration: 0.5)
                .onEnded { _ in
                    if booleanArray[currentDayIndex] == 0 {
                        booleanArray[currentDayIndex] = 1
                    } else {
                        booleanArray[currentDayIndex] = 0
                    }
                    UserDefaults.standard.set(booleanArray, forKey: "booleanArray")
                    UserDefaults.standard.set(isHoldingButton, forKey: "HoldingButton")
                } : LongPressGesture(minimumDuration: 0.5)
                .onEnded { _ in
                    print("NOTHING \(selectedDayIndex + currentDayIndex )!= \(currentDayIndex)")
                })
            .sheet(isPresented: $isPresentingPopupSheet , onDismiss: {
                // Perform any action you want when the sheet is dismissed
            }) {
                // Specify the content of the sheet using the SheetContentView
                DetailGoalView(targetIndices: booleanArray, stringValue: messageTemp, arrayValue: storedTexts ?? [])
            }
            HStack(alignment: .top) {
                Circle().frame(width: 12, height: 12).offset(y:4).foregroundColor(.gray)
                    .opacity(0.3)
                Text("Remember to keep the task reachable or at least enough to do the next day but careful of letting all that work pile up")
                    .font(.system(size: 14, weight: .regular))
            }.padding()
            Button("Delete week journey") {
                messageTemp = ""
                UserDefaults.standard.set(blankArray, forKey: "NextSevenDays")
                isGenerated.toggle()
            }.foregroundColor(.red)
        }
    }
}
