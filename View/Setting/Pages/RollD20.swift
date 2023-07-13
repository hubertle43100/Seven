//
//  RollD20.swift
//  TinyHabits
//
//  Created by Hubert Le on 10/20/22.
//

import SwiftUI

struct RollD20: View {
    var body: some View {
        VStack {
            DiceView()
            
        }
    }
}

struct RollD20_Previews: PreviewProvider {
    static var previews: some View {
        RollD20()
    }
}

struct DiceView: View {
    @State var d1 = 0; @State var d2 = 0
    @State var textFieldText1: String = ""
    @State var textFieldText2: String = ""
    @State var point1 = 0; @State var point2 = 0;
    var body: some View {
        VStack {
            BounceAnimationView(text: "Indecisive", startTime: 0.0)
            HStack {
                Text("\(point1)").padding()
                Spacer()
                Text("\(point2)").padding()
            }
            ZStack {
                HStack {
                    VStack {
                        TextField("Type task here...", text: $textFieldText1)
                            .padding()
                            .background(Color.gray.opacity(0.3).cornerRadius(10))
                            .foregroundColor(.black)
                            .font(Font.custom("SourceCodePro-Bold", size: 15))
                        ZStack {
                            Image(systemName: "hexagon.fill")
                                .foregroundColor(.orange)
                                .font(.system(size: 125))
                            Text("     ")
                                .animatingOverlay(for: Double(d1))
                                .font(Font.custom("SourceCodePro-Bold", size: 35))
                        }
                    }
                    VStack {
                        TextField("Type task here...", text: $textFieldText2)
                            .padding()
                            .background(Color.gray.opacity(0.3).cornerRadius(10))
                            .foregroundColor(.black)
                            .font(Font.custom("SourceCodePro-Bold", size: 15))
                        ZStack {
                            
                            Image(systemName: "hexagon.fill")
                                .foregroundColor(.orange)
                                .font(.system(size: 125))
                            Text("     ")
                                .animatingOverlay(for: Double(d2))
                                .font(Font.custom("SourceCodePro-Bold", size: 35))
                            
                        }
                    }
                }.padding()
                
                Button {
                    withAnimation {
                        d1 = Int.random(in: 1...20)
                        d2 = Int.random(in: 1...20)
                        if d1 > d2 {
                            point1 += 1
                        } else if d2 > d1 {
                            point2 += 1
                        }
                        if point1 == 4 || point2 == 4 {
                            point1 = 0
                            point2 = 0
                        }
                    }
                    
                } label: {
                    Text("Roll (first to 3 points)")
                        .font(Font.custom("SourceCodePro-Bold", size: 40))
                        .padding()
                        .foregroundColor(.white)
                        .background(.gray)
                        .cornerRadius(8)
                        .offset(y:45)
                        .opacity(0)
                }
            }
            Spacer()
        }
    }
}

struct AnimatableNumberModifier: AnimatableModifier {
    var number: Double
    
    var animatableData: Double {
        get { number }
        set { number = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Text("\(Int(number))")
            )
    }
}

extension View {
    func animatingOverlay(for number: Double) -> some View {
        modifier(AnimatableNumberModifier(number: number))
    }
}
