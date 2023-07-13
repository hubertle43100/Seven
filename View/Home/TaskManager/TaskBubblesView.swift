//
//  TaskBubbles.swift
//  TinyHabits
//
//  Created by Hubert Le on 7/21/22.
//

import SwiftUI

struct TaskBubblesView: View {
    var task: String; var colorData = ColorData()
    @State var isDiffClicked: Bool = false; @State var isMotiClicked: Bool = false
    @State var ratingD: Int = 0; @State var ratingM: Int = 0
    @State var color: Color = Color.white;@State var fore: Color = Color.blue
    @Binding var rootIsActive : Bool
    
    var body: some View {
        
        ZStack {
            color
                .ignoresSafeArea()
            VStack{
                TaskDisplay(isComplete: false, fore: fore, task: task, title: "Click the circles")
                SelectDifficulty(task: task, ratingD: ratingD, ratingM: ratingM, isDiffClicked: isDiffClicked, isMotiClicked: isMotiClicked, color: color, fore: fore, rootIsActive: $rootIsActive)
            }
        }.onAppear {
            color = colorData.loadColor()
            fore = colorData.loadForegroundColor()
        }
    }
}










struct SelectDifficulty: View {
    var task: String; var colorData = ColorData()
    @State var ratingD: Int;@State var ratingM: Int
    @State var isDiffClicked: Bool;@State var isMotiClicked: Bool
    @State var color: Color;@State var fore: Color
    @Binding var rootIsActive : Bool
    
    var body: some View {
        VStack {
            Group {
                Text("Difficulty of Task").padding()
                HStack {
                    ForEach(1..<11) { index in
                        Image(systemName: "circle.fill")
                            .font(.system(size: 15))
                            .foregroundColor(ratingD >= index ? fore : Color.gray)
                            .onTapGesture {
                                ratingD = index
                                isDiffClicked = true
                            }
                    }
                }.padding(.bottom,5)
                HStack {
                    Text("Hard");Spacer();Text("Easy")
                }.frame(width: 300)
                    .padding(.bottom)
                
                
                Text("Motivation for Task").padding()
                HStack {
                    ForEach(1..<11) { index in
                        Image(systemName: "circle.fill")
                            .font(.system(size: 15))
                            .foregroundColor(ratingM >= index ? fore : Color.gray)
                            .onTapGesture {
                                ratingM = index
                                isMotiClicked = true
                            }
                    }
                }.padding(.bottom,5)
                HStack {
                    Text("Low");Spacer();Text("High")
                }.frame(width: 300)
                    .padding(.bottom)
            }.font(Font.custom("SourceCodePro-Bold", size: 15))
            
            if isDiffClicked && isMotiClicked {
                NavigationLink(destination: TaskSaveView(task: task, shouldPopToRootView: self.$rootIsActive, progressValue: Float(ratingD + ratingM)/20), label: {
                    Text("Continue to Task Analysis")
                        .padding()
                        .foregroundColor(.white)
                        .background(fore)
                        .cornerRadius(8)
                        .font(Font.custom("SourceCodePro-Bold", size: 15))
                    
                }).isDetailLink(false)
            } else {
                Text("Continue to Task Analysis").padding().font(Font.custom("SourceCodePro-Bold", size: 15)).opacity(0)
            }
        }.onAppear {
            color = colorData.loadColor()
            fore = colorData.loadForegroundColor()
        }
    }
}

