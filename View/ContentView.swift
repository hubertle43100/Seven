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
    
    var body: some View {
        ZStack {
            VStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 433, height: 200)
                    .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                Spacer()
            }.onAppear {
                testFunction()
            }
            DateHeaderView(selectedDayIndex:  $selectedDayIndex)
                if storedTexts?.count == 0 || messageTemp == "" {
                    GetStartedView()
                } else {
                    // Display the stored text below the "HERE" button
                    taskDisplayView(selectedDayIndex:  $selectedDayIndex, currentDayIndex: $currentDayIndex)
                }
        }.onChange(of: messageTemp) { newValue in
            UserDefaults.standard.set(newValue, forKey: "messageTemp")
        }
    }
    func testFunction() {
        let date = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Format to get the numeric date (e.g., 01, 02, 03)
        let formattedDate = dateFormatter.string(from: date)
        
        print("ARRAY 1: \(formattedDate)")
        print("ARRAY 2: \(currentDayArray ?? [])")
        
        if let currentDayArray = currentDayArray as? [String] {
            if let index = currentDayArray.firstIndex(of: formattedDate) {
                print("The index of the matching date is: \(index)")
                currentDayIndex = index
                print(currentDayIndex)
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

struct DateHeaderView: View {
    let dateFormatter = DateFormatter()
    @State var Num: Float = -113
    @Binding var selectedDayIndex: Int
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 61, height: 44)
                    .background(.white)
                    .cornerRadius(5)
                    .offset(x:110)
                HStack {
                    VStack {
                        Text("Welcome").font(.system(size: 30, weight: .semibold, design: .default))
                        Text("Back").font(.system(size: 12, weight: .medium, design: .default)).opacity(0.3).offset(x:50)
                        
                    }.padding(.bottom, 0)
                    Spacer()
                    Text("H.L.").font(.system(size: 20, weight: .semibold, design: .default))
                    Spacer()
                }.offset(x:50)
            }.padding()
            GeometryReader { geometry in
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 42, height: 72)
                        .background(.white)
                        .cornerRadius(5)
                        .offset(x: CGFloat(Num))
                    HStack {
                        
                        Text("Tiny Habits").font(.system(size: 12, weight: .semibold, design: .default))
                            .rotationEffect(Angle(degrees: -90)).opacity(0.3).offset(x: 20)
                        //Divider().frame(height: 50).overlay(.gray)
                        HStack(spacing: 20) {
                            ForEach(0..<7) { index in
                                VStack {
                                    VStack {
                                        Button("\(self.getDayAbbreviation(for: index))\n\(self.getDate(for: index))") {
                                            self.Num = -113 + Float(index * 42)
                                            
                                            dayChoosen(index: index)
                                            
                                        }
                                    }
                                    .font(.system(size: 18, weight: .semibold, design: .default))
                                        .foregroundColor(.black)
                                        
                                }
                            }
                        }
                        Spacer()
                    }
                }.padding()
            }
            Spacer()
        }
    }
    func getDayAbbreviation(for index: Int) -> String {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let adjustedIndex = (index + calendar.component(.weekday, from: startOfDay) - 1) % 7
        let weekdays = calendar.veryShortWeekdaySymbols
        return weekdays[adjustedIndex]
    }
    func getDate(for index: Int) -> String {
        let date = Calendar.current.date(byAdding: .day, value: index, to: Date()) ?? Date()
        dateFormatter.dateFormat = "dd" // Format to get the numeric date (e.g., 01, 02, 03)
        let formattedDate = dateFormatter.string(from: date)
        
        return formattedDate
    }
    func dayChoosen(index: Int) {
        selectedDayIndex = index
    }
}

struct GetStartedView: View {
    @State private var isFullScreenPresented = false
    @State private var storedTexts: [String] = [] // New state variable to store the retrieved text
    @State private var messageTemp: String = ""
    
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
                            generateGoals(isFullScreenPresented: $isFullScreenPresented, onDismiss: { receivedStoredTexts,receivedMessageTemp  in
                                // This closure is called when generateGoals is dismissed,
                                // and it receives the storedTexts array back from generateGoals.
                                // You can handle the array here as needed.
                                print("Received storedTexts:", receivedStoredTexts)
                                storedTexts = receivedStoredTexts
                                messageTemp = receivedMessageTemp
                                let userDefaults = UserDefaults.standard
                                userDefaults.set(storedTexts, forKey: "receivedStoredTexts")
                                userDefaults.set(messageTemp, forKey: "messageTemp")
                                
                                saveNextSevenDaysToUserDefaults()
                            })
                        }
                }
                
            }.offset(x:-20).padding()
            Divider().frame(width: 70).overlay(.gray).rotationEffect(Angle(degrees: -90)).padding(50)
            HStack {
                Image("Ellipse 2")
                    .frame(width: 15, height: 15).offset(x:15,y: -12)
                Text("Create a task for the next few days or even the whole week").frame(width: 262, height: 56, alignment: .center)
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
    @State var storedTexts = UserDefaults.standard.array(forKey: "receivedStoredTexts") as? [String]
    @State private var messageTemp = UserDefaults.standard.string(forKey: "messageTemp") ?? ""
    @State private var isPresentingPopupSheet = false
    @Binding var selectedDayIndex: Int
    @Binding var currentDayIndex: Int
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
                            VStack {
                                VStack {
                                    HStack {
                                        Text(storedTexts?[selectedDayIndex + currentDayIndex] ?? "")
                                        Spacer()
                                    }
                                    HStack {
                                        Spacer()
                                        Text("Hold for completion")
                                            .font(.system(size: 14, weight: .semibold))
                                            .opacity(0.5)
                                            .padding(.top, 5)
                                    }
                                }.padding()
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(8)
                                    .onTapGesture {
                                        // This will present the sheet when the VStack is tapped
                                        isPresentingPopupSheet  = true
                                    }
                                    .sheet(isPresented: $isPresentingPopupSheet , onDismiss: {
                                        // Perform any action you want when the sheet is dismissed
                                        print("Sheet dismissed")
                                    }) {
                                        // Specify the content of the sheet using the SheetContentView
                                        detailGoalView(stringValue: messageTemp, arrayValue: storedTexts ?? [])
                                    }
                                HStack(alignment: .top) {
                                    Circle().frame(width: 12, height: 12).offset(y:4).foregroundColor(.gray)
                                        .opacity(0.3)
                                    Text("Remember to keep the task reachable or at least enough to do the next day but careful of letting all that work pile up")
                                        .font(.system(size: 14, weight: .regular))
                                }.padding()
                            }
                        } else {
                            Text("SHUT UP")
                        }
                    }.font(.system(size: 18, weight: .semibold))
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                    Spacer()
                }
            }
            
            Spacer()
            Text("Delete Task").foregroundColor(.red)
        }.frame(maxWidth: 375)
            .offset(y:250)
    }
}
