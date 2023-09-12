//
//  DateHeaderView.swift
//  Seven
//
//  Created by Hubert Le on 9/11/23.
//

import SwiftUI

struct DateHeaderView: View {
    let dateFormatter = DateFormatter()
    @State var Num: Float = -155
    @Binding var selectedDayIndex: Int
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 91, height: 44)
                    .background(.white)
                    .cornerRadius(5)
                    .offset(x:110)
                HStack {
                    VStack {
                        Text("Welcome").font(.system(size: 30, weight: .semibold, design: .default))
                        Text("Back").font(.system(size: 12, weight: .medium, design: .default)).opacity(0.3).offset(x:50)
                        
                    }.padding(.bottom, 0)
                    Spacer()
                    Text("NEED").font(.system(size: 20, weight: .semibold, design: .default))
                    Spacer()
                }.offset(x:45)
            }.padding()
            GeometryReader { geometry in
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 52, height: 72)
                        .background(.white)
                        .cornerRadius(5)
                        .offset(x: CGFloat(Num))
                    HStack {
                        HStack(spacing: 20) {
                            ForEach(0..<7) { index in
                                VStack {
                                    VStack {
                                        Button("\(self.getDayAbbreviation(for: index))\n\(self.getDate(for: index))") {
                                            self.Num = -155 + Float(index * 50)
                                            
                                            dayChoosen(index: index)
                                            
                                        }
                                    }
                                    .font(.system(size: 18, weight: .semibold, design: .default))
                                    .foregroundColor(.black)
                                    
                                }
                            }.frame(width:30)
                        }.padding(.leading, 30)
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
