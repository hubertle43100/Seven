//
//  ContentView.swift
//  TinyHabits
//
//  Created by Hubert Le on 7/7/22.
//

import SwiftUI

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
            
            ExtractedView()
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
                            print("Button tapped!")
                        }.font(.system(size: 50, weight: .semibold, design: .default))
                            .foregroundColor(.black)
                        
                    }
                }.offset(x:-20).padding()
                Divider().frame(width: 70).overlay(.gray).rotationEffect(Angle(degrees: -90)).padding(50)
                HStack {
                    Image("Ellipse 2")
                        .frame(width: 15, height: 15).offset(x:15,y: -12)
                    Text("Create a task for the next few days or even the whole week").frame(width: 262, height: 56, alignment: .center)
                }
            }.offset(y:100)
        }
        //        TabView {
        //            HabitMain(model: vm)
        //                .tabItem {
        //                    VStack {
        //                        Text("Habits")
        //                        Image(systemName: "pencil.circle.fill")
        //                            .renderingMode(.template)
        //                    }
        //
        //                }
        //
        //            SettingMain()
        //                .tabItem {
        //                    VStack {
        //                        Text("Setting")
        //                        Image(systemName: "line.horizontal.3.decrease.circle.fill")
        //                            .renderingMode(.template)
        //                    }
        //                }
        //        }.accentColor(Color.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




struct ExtractedView: View {
    let dateFormatter = DateFormatter()
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
                    .frame(width: 40, height: 72)
                    .background(.white)
                    .cornerRadius(5)
                    .offset(x:-101)
                HStack {
                    
                    Text("Tiny Habits").font(.system(size: 12, weight: .semibold, design: .default))
                        .rotationEffect(Angle(degrees: -90)).opacity(0.3).offset(x: 30)
                    Divider().frame(height: 50).overlay(.gray)
                    VStack {
                        HStack(spacing: 29) {
                                   ForEach(0..<7) { index in
                                       Text("\(self.getDayAbbreviation(for: index))").font(.system(size: 20, weight: .medium, design: .default))
                                   }
                        }.offset(x:10)
                        HStack(spacing: 20) {
                            ForEach(0..<7) { index in
                                Text("\(self.getDate(for: index))").font(.system(size: 18, weight: .medium, design: .default))
                            }
                        }.offset(x:5)
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
    
}
