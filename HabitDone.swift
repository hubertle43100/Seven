//
//  HabitDone.swift
//  TinyHabits
//
//  Created by Hubert Le on 7/25/22.
//

import SwiftUI

struct HabitDone: View {
    //@State var progressValue: Float
    @StateObject var model: CoreDataViewModel
    
    var body: some View {
        VStack {
            Header().navigationBarBackButtonHidden(true)
            ForEach(model.savedEntities) { entity in
                //progressValue = entity.progressValue
                Button {
                    model.quickDeleteHabit()
                } label: {
                    VStack {
                        Text(entity.task ?? "Task Not found!")
                        //ProgressBar(value: $progressValue).frame(height: 20)
                            .padding(.leading)
                            .padding(.trailing)
                    }
                }.frame(width: 300, height: 100)
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(8)
                    .font(Font.custom("SourceCodePro-Bold", size: 15))
            }
        }
    }
}

