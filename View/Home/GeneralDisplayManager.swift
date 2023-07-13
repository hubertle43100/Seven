//
//  GeneralDisplayManager.swift
//  TinyHabits
//
//  Created by Hubert Le on 10/4/22.
//

import Foundation
import SwiftUI

struct TaskDisplay: View {
    @State var isComplete: Bool
    @State var fore: Color
    var task: String
    var title: String
    var colorData = ColorData()
    
    var body: some View {
        VStack {
            BounceAnimationView(text: "\(title)", startTime: 0.0)
            VStack {
                Text(task)
                    .strikethrough(isComplete)
                    .padding()
            }.foregroundColor(.white)
                .frame(width: 300, height: 100)
                .background(fore)
                .cornerRadius(8)
                .font(Font.custom("SourceCodePro-Bold", size: 15))
        }.onAppear {
            fore = colorData.loadForegroundColor()
        }
        .padding(.bottom, 50)
            
    }
}

struct SettingHeader: View {
    var title: String
    var description: String
    var body: some View {
        VStack {
            HStack {
                Text("\(title)")
                    .font(Font.custom("SourceCodePro-Bold", size: 20))
                Spacer()
            }
            Text("\(description)").opacity(0.7)
                .font(Font.custom("SourceCodePro-Bold", size: 15))
        }.multilineTextAlignment(.leading)
            .padding()
            .offset(x:-6)
    }
}
