//
//  SaveTask.swift
//  TinyHabits
//
//  Created by Hubert Le on 7/21/22.
//

import SwiftUI
import CoreData

struct TaskSaveView: View {
    var task: String; var colorData = ColorData()
    @StateObject var vm = CoreDataViewModel()
    @Binding var shouldPopToRootView : Bool
    @State var color: Color = Color.white;@State var fore: Color = Color.blue
    @State var progressValue: Float
    
    var body: some View {
        ZStack {
            color.ignoresSafeArea() //Color background
            VStack {
                
                //General Headers
                TaskDisplay(isComplete: false, fore: fore, task: task, title: "Finalize Task")
                
                //Display tips or continue view depending on progress value
                if progressValue < 0.6 {
                    Tips(decimal: progressValue)
                } else {
                    Continue(task: task, progressValue: progressValue, shouldPopToRootView: $shouldPopToRootView)
                };Spacer()
            }
        }.onAppear {
            color = colorData.loadColor()
            fore = colorData.loadForegroundColor()
        }
    }
}









//MARK: TaskSave Components

struct ProgressBar: View {
    //[Summary] - Creation of Progress Bar with GeometryReader
    
    var value: Float
    @State var fore: Color = Color.blue
    var colorData = ColorData()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color.gray)
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(fore)
            }.cornerRadius(45.0)
        }.onAppear {
            fore = colorData.loadForegroundColor()
        }
    }
}

struct Tips: View {
    //[Summary] - Present static display when progressValue < 60
    
    
    @State var decimal: Float
    
    var body: some View {
        Group {
            let formattedFloat = String(format: "%.0f", decimal * 100)
            Text("Your Percentage: \(formattedFloat)%").font(Font.custom("SourceCodePro-Bold", size: 15))
            VStack {
                ProgressBar(value: decimal).frame(height: 20)
            }.padding()
            Text("^").offset(x:35, y:-10)
            Text("60%")
                .padding(.bottom)
                .offset(x:35)
            Group {
                //Header; Instruction
                Text("+ Anchor the Task");Text("Floss teeth --> Floss teeth after brushing teeth")
                    .opacity(0.5)
                    .padding(.bottom)
                Text("+ Make the task less difficult");Text("10 Push ups --> 5 Push ups")
                    .opacity(0.5)
                    .padding(.bottom)
                Text("+ It’s too general");Text("Drink water --> drink 20 oz water before breakfast")
                    .opacity(0.5)
            }.frame(width: 300, alignment: .leading)
        }.font(Font.custom("SourceCodePro-Bold", size: 15))
    }
}

struct Continue: View {
    //[Summary] - Present Successful display & Add task to HabitEntities array
    
    var task: String
    var colorData = ColorData()
    
    @State var progressValue: Float
    @State var fore: Color = Color.blue
    @StateObject var vm = CoreDataViewModel()
    @Binding var shouldPopToRootView : Bool
    
    var body: some View {
        VStack {
            Image("confetti")
                .resizable()
                .padding()
                .background(fore)
                .frame(width: 125, height: 125)
                .cornerRadius(10)
            Text("Nicely done!\n\nGo ahead and start building good habits!").padding().font(Font.custom("SourceCodePro-Bold", size: 14))
                .frame(width: 350)
                .multilineTextAlignment(.leading)
            Button(action: {
                self.shouldPopToRootView = false
                vm.addHabit(text: task, nums: progressValue)
            }) {
                Text("Let's get started").font(Font.custom("SourceCodePro-Bold", size: 15))
            }.padding()
                .foregroundColor(.white)
                .background(fore)
                .cornerRadius(8)
        }.onAppear {
            fore = colorData.loadForegroundColor()
        }
    }
}





