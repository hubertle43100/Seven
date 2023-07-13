//
//  TaskTitle.swift
//  TinyHabits
//
//  Created by Hubert Le on 7/27/22.
//

import Foundation
import SwiftUI

struct TaskTitleView: View {
    var colorData = ColorData()
    @Binding var rootIsActive : Bool
    @State var TitleTextfield: String = ""
    @State var color: Color = Color.black;@State var fore: Color = Color.black
    
    var body: some View {
        ZStack {
            color
            .ignoresSafeArea()
            VStack {
                BounceAnimationView(text: "Enter Habit", startTime: 0.0)
                inputTask(fore: fore)
                Nextbutton(TitleTextfield: TitleTextfield, rootIsActive: $rootIsActive, fore: fore);Spacer()
            }
        }.onAppear {
            TitleTextfield = TitleTextfield
            color = colorData.loadColor()
            fore = colorData.loadForegroundColor()
        }
    }
}


















struct inputTask: View {
    var colorData = ColorData()
    @State var fore: Color

    
    var body: some View {
        VStack {
            Image("box")
                .resizable()
                .padding()
                .background(fore)
                .frame(width: 125, height: 125)
                .cornerRadius(10)
            Text("Make your task as specific as possible. Doing this will allow you to visualize yourself in the position of practicing building your new habit. (At least 20 characters)").padding().font(Font.custom("SourceCodePro-Bold", size: 14))
                .frame(width: 350)
                .multilineTextAlignment(.leading)
        }.onAppear {
            fore = colorData.loadForegroundColor()
        }
    }
}

struct Nextbutton: View {
    var colorData = ColorData()
    @State var TitleTextfield: String
    @Binding var rootIsActive : Bool
    @State var fore: Color
    
    var body: some View {
        VStack {
            TextField("10 Push ups after going to the restroom", text: $TitleTextfield)
                .padding()
                .background(Color.gray.opacity(0.3).cornerRadius(10))
                .font(Font.custom("SourceCodePro-Bold", size: 13))
                .padding()
            if isValidTask() {
                NavigationLink(destination: TaskBubblesView(task: TitleTextfield, rootIsActive: self.$rootIsActive),
                               label: {
                    Text("Continue to Task Analysis")
                        .padding()
                        .foregroundColor(.white)
                        .background(fore)
                        .cornerRadius(8)
                        .font(Font.custom("SourceCodePro-Bold", size: 15))
                    
                }).isDetailLink(false)
            }
        }.onAppear {
            fore = colorData.loadForegroundColor()
        }
    }
    
    func isValidTask() -> Bool {
        if TitleTextfield.count >= 20 {
            return true
        }
        return false
    }
}
