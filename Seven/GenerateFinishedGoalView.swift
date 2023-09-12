//
//  GenerateFinishedGoalView.swift
//  Seven
//
//  Created by Hubert Le on 9/11/23.
//

import SwiftUI

struct GenerateFinishedGoalView: View {
    @State private var promptText: String = ""
    @State private var generatedText: String = ""
    @State private var message: String = ""
    @State private var messageTemp: String = ""
    @State private var storedTexts: [String] = []
    @State private var isScrollViewVisible: Bool = false
    @State private var offset: CGFloat = 0
    
    @State private var isLoading = false
    
    @Binding var isFullScreenPresented: Bool
    
    typealias StoredTextsCallback = ([String],String) -> Void
    var onDismiss: StoredTextsCallback?
    
    @Environment(\.presentationMode) var presentationMode
    //private let openAI = OpenAI(apiToken: "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")
    
    var body: some View {
        HStack {
            Text("7 day plan")
                .font(.system(size: 15, weight: .semibold, design: .default))
            Spacer()
        }.padding(.leading, 16)
            .padding(.bottom, 1)
            .opacity(0.5)
        HStack {
            Text("\(messageTemp)").font(.system(size: 25, weight: .semibold, design: .default))
                .font(.headline)
            Text(
            Spacer()
        }.padding(.leading, 16)

            ScrollView {
                if isLoading {
                    ProgressView("Generating goal for the week...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .font(.headline)
                        .offset(y: 250)
                } else {
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 16)], spacing: 16) {
                        ForEach(storedTexts, id: \.self) { data in
                            NumberTextCell(data: data)
                        }
                    }
                    .padding()
                }
            }
        if !isLoading {
            Button(action: confirmGoals) {
                HStack {
                    Spacer()
                    Image(systemName: "checkmark.circle.fill") // Use checkmark.circle.fill symbol
                        .font(.system(size: 16, weight: .bold)) // Set the weight to .bold
                        .foregroundColor(.white)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                    Text("Looks Good!") // Text view for the button text
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                .background(Color.green) // Apply the green background to the HStack
                .cornerRadius(8)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
        }
    }
    func confirmGoals() {
        print("CAstle: \(storedTexts)")
        onDismiss?(storedTexts, messageTemp)
        presentationMode.wrappedValue.dismiss()
        
    }
}

struct GenerateFinishedGoalView_Previews: PreviewProvider {
    static var previews: some View {
        GenerateFinishedGoalView(isFullScreenPresented: .constant(true))
    }
}
