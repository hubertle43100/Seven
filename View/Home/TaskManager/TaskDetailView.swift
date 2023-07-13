//
//  TaskDetail.swift
//  TinyHabits
//
//  Created by Hubert Le on 9/15/22.
//

import SwiftUI

struct TaskDetailView: View {
    var CircleProgress: Float
    var task: String
    @State var isComplete: Bool
    @State var fore: Color
    var colorData = ColorData()
    
    @StateObject var vm = CoreDataViewModel()
    
    var body: some View {
        let formattedFloat = String(format: "%.0f", CircleProgress)
        ScrollView {
            VStack {
                TaskDisplay(isComplete: isComplete, fore: fore, task: task, title: "Task Detail")
                Text("Days in a row: \(formattedFloat)")
                    .font(Font.custom("SourceCodePro-Bold", size: 15))
                    .padding(.bottom, 10)
                CircleDisplay(CircleProgress: CircleProgress, formattedFloat: formattedFloat)
                Fact()
                Button(action: {
                    
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(Color.black)
                        .font(.system(size: 20))
                }
            }.onAppear {
                fore = colorData.loadForegroundColor()
            }
        }
    }
}

struct TaskDetail_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(CircleProgress: 12, task: "Going to gym before 7 am", isComplete: true, fore: .red)
    }
}










struct Fact: View {
    var body: some View {
        Text("It only takes averagely about 21 days to build a stable habit. Keep it up!")
            .frame(width: 300, height: 100)
            .font(Font.custom("SourceCodePro-Bold", size: 15))
    }
}

struct CircleDisplay: View {
    var CircleProgress: Float
    let formattedFloat: String
    
    var body: some View {
        ZStack {
            CircleWheel(CircleProgress: CircleProgress)
            Text("\(formattedFloat)/21")
                .font(Font.custom("SourceCodePro-Bold", size: 40))
                .bold()
        }.padding()
    }
}

struct CircleColors: View {
    var circleColor: Color
    @State var CircleProgress: Float
    @State var tempCP: Float = 0
    
    var body: some View {
        ZStack{
            Circle()
                .stroke(circleColor.opacity(0.5), lineWidth: 30)
                .frame(width: 200, height: 200)
            Circle()
                .trim(from: 0, to: CGFloat(CircleProgress)/21)
                .stroke(circleColor, style: StrokeStyle(
                    lineWidth: 30,
                    lineCap: .round
                ))
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: CircleProgress)
        }.onTapGesture {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                tempCP = CircleProgress
                CircleProgress = 0
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                CircleProgress = tempCP
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                tempCP = CircleProgress
                CircleProgress = 0
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                CircleProgress = tempCP
            }
        }
    }
    
}

struct CircleWheel: View {
    var CircleProgress: Float
    var body: some View {
        switch CircleProgress {
        case 0...7:
            CircleColors(circleColor: Color.red, CircleProgress: CircleProgress)
        case 8...14:
            CircleColors(circleColor: Color.yellow, CircleProgress: CircleProgress)
        case 15...21:
            CircleColors(circleColor: Color.green, CircleProgress: CircleProgress)
        default:
            Text("Error in there is a value out of bounds")
        }
    }
}
