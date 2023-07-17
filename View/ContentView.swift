//
//  ContentView.swift
//  TinyHabits
//
//  Created by Hubert Le on 7/7/22.
//

import SwiftUI
import EventKit

struct ContentView: View {
    
    //@StateObject var vm = CoreDataViewModel()
    var body: some View {
        ZStack {
            VStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 433, height: 200)
                    .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                Spacer()
            }
            
            
            dateHeader()
            ExtractedView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct dateHeader: View {
    let dateFormatter = DateFormatter()
    @State var Num: Int = -106
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
                    Text("S.L.").font(.system(size: 20, weight: .semibold, design: .default))
                    Spacer()
                }.offset(x:50)
            }.padding()
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 30, height: 72)
                    .background(.white)
                    .cornerRadius(5)
                    .offset(x:CGFloat(Num))
                HStack {
                    
                    Text("Tiny Habits").font(.system(size: 12, weight: .semibold, design: .default))
                        .rotationEffect(Angle(degrees: -90)).opacity(0.3).offset(x: 30)
                    Divider().frame(height: 50).overlay(.gray)
                    HStack(spacing: 20) {
                        ForEach(0..<7) { index in
                            VStack{
                                Group {
                                    Text("\(self.getDayAbbreviation(for: index))")
                                    Button("\(self.getDate(for: index))") {
                                        self.Num = -106 + 40 * index
                                        dayChoosen()
                                    }
                                }.font(.system(size: 18, weight: .semibold, design: .default))
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    Spacer()
                }
            }.padding()
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
        return dateFormatter.string(from: date)
    }
    func dayChoosen(){
        print("DayChoosen: \(Num)")
        Num = Num
    }
}

struct ExtractedView: View {
    @State private var showSecondView: Bool = false
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
                        showSecondView = true
                    }.font(.system(size: 50, weight: .semibold, design: .default))
                        .foregroundColor(.black)
                        .sheet(isPresented: $showSecondView) {
                            // Present the second view as a sheet
                            generateGoals()
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
}

extension ContentView {
    func requestCalendarAccess() {
        let eventStore = EKEventStore()
        
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            print("Calendar access already authorized.")
            // You can proceed to add events to the calendar here.
        case .denied:
            print("Calendar access denied.")
        case .notDetermined:
            eventStore.requestAccess(to: .event) { granted, error in
                if granted {
                    print("Calendar access granted.")
                    // You can proceed to add events to the calendar here.
                } else {
                    print("Calendar access denied.")
                }
            }
        case .restricted:
            print("Calendar access restricted.")
        @unknown default:
            print("Unknown authorization status.")
        }
    }
}
