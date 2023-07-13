//
//  ColorThemes.swift
//  TinyHabits
//
//  Created by Hubert Le on 8/18/22.
//

import SwiftUI

struct ColorThemes: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var color: Color = Color.white
    @State private var fore: Color = Color.white
    @State var isNavigationBarHidden: Bool = true
    
    private var colorData = ColorData()
    
    var names: [String] = ["Default white",
                           "Red",
                           "Orange",
                           "Yellow",
                           "Green",
                           "Blue",
                           "Purple"]
    var colors: [Color] = [Color.white,
                           Color(.init(srgbRed: 255/255, green: 209/255, blue: 208/255, alpha: 1.0)),
                           Color(.init(srgbRed: 255/255, green: 230/255, blue: 208/255, alpha: 1.0)),
                           Color(.init(srgbRed: 255/255, green: 254/255, blue: 208/255, alpha: 1.0)),
                           Color(.init(srgbRed: 220/255, green: 255/255, blue: 208/255, alpha: 1.0)),
                           Color(.init(srgbRed: 208/255, green: 242/255, blue: 255/255, alpha: 1.0)),
                           Color(.init(srgbRed: 255/255, green: 208/255, blue: 248/255, alpha: 1.0))]
    
    var body: some View {
        NavigationView {
                VStack {
                    BounceAnimationView(text: "Choose Color", startTime: 0.0).padding(.bottom, 50)
                    VStack {
                        ForEach(Array(names.enumerated()),id: \.offset) { index, element in
                            Button {
                                color = colors[index]
                                colorData.saveColor(color: color)
                            } label: {
                                ColorButton(NameColor: names[index], ButtonColor: colors[index])
                            }
                            
                        }
                    }
                    Spacer()
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(color)
                .navigationBarHidden(self.isNavigationBarHidden)
                .onAppear {
                    self.isNavigationBarHidden = true
                    color = colorData.loadColor()
                    fore = colorData.loadForegroundColor()
            }
        }
    }
}

struct ColorThemes_Previews: PreviewProvider {
    static var previews: some View {
        ColorThemes()
    }
}










struct ColorButton: View {
    var NameColor: String
    var ButtonColor: Color
    
    var body: some View {
        VStack {
            Text(NameColor)
                .frame(width: 300, height: 50)
                .font(Font.custom("SourceCodePro-Bold", size: 15))
                .foregroundColor(.black)
                .background(ButtonColor)
                .cornerRadius(8)
        }
    }
}


extension View {
    //Navigate to a New View
    //Parameters:
    //  -   view: View to navigate to.
    //  -   binding: Only navigates when this condition is 'true'
    
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
        NavigationView {
            ZStack {
                self
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                
                NavigationLink(
                    destination: view
                        .navigationBarTitle("")
                        .navigationBarHidden(true),
                    isActive: binding
                ) {
                    EmptyView()
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
