//
//  GenerateGoalView.swift
//  Seven
//
//  Created by Hubert Le on 8/17/23.
//

import SwiftUI
import OpenAI

struct GenerateGoalView: View {
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
    private let openAI = OpenAI(apiToken: "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")
    
    var body: some View {
        VStack {
            if !isScrollViewVisible {
                VStack {
                    Text("Create goals").font(.system(size: 30, weight: .semibold, design: .default)).padding()
                    Text("Presets").font(.system(size: 20, weight: .semibold, design: .default)).padding(.top, 20)
                    VStack(spacing: 20) {
                        BoxTextView(iconName: "scalemass", text: "Lose weight and maintain a healthy lifestyle.", message: $message)
                        BoxTextView(iconName: "dollarsign.circle", text: "Save money and build a strong financial foundation", message: $message)
                        BoxTextView(iconName: "heart.circle", text: "Prioritize self-care and nurture emotional well-being.", message: $message)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    HStack {
                        TextField("Type your message...", text: $message)
                            .padding()
                            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                                    self.moveView(up: true, keyboardHeight: keyboardFrame.height)
                                }
                            }
                            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                                self.moveView(up: false)
                            }
                            .onTapGesture {
                                // Dismiss the keyboard when tapping outside of the text field
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        
                        Button(action: sendMessage) {
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.green)
                                .cornerRadius(8)
                        }
                        .padding(.trailing)
                    }
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding()
                }
            }
            if isScrollViewVisible {
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
        }
        .padding()
    }
    private func moveView(up: Bool, keyboardHeight: CGFloat = 0) {
        if up {
            self.offset = keyboardHeight * 0.9 // Adjust the offset as needed
        } else {
            self.offset = 0
        }
    }
    func confirmGoals() {
        print("CAstle: \(storedTexts)")
        onDismiss?(storedTexts, messageTemp)
        presentationMode.wrappedValue.dismiss()
        
    }
    func sendMessage() {
        isLoading = true
        // Fetch generated text
        fetchGeneratedText()
        
        messageTemp = message
        
        // Clear the message
        message = ""
        
        isScrollViewVisible = true
        
    }
    
    func fetchGeneratedText() {
        let query = CompletionsQuery(model: .textDavinci_003, prompt: "Generate specific goals for 7 days for this goal and one sentence for each day for this goal and make it a bit difficult: \(message)", temperature: 0, maxTokens: 200, topP: 1, frequencyPenalty: 0, presencePenalty: 0, stop: ["\\n"])
        openAI.completions(query: query) { result in
            switch result {
            case .success(let completionResponse):
                if let generatedChoice = completionResponse.choices.first {
                    generatedText = generatedChoice.text
                    let modifiedText = generatedText.replacingOccurrences(of: "\n\n", with: "")
                    let daysArray = modifiedText.components(separatedBy: "Day ")
                    let trimmedArray = daysArray.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    storedTexts.append(contentsOf: trimmedArray)
                    print("Choosing goals: \(storedTexts)")
                    storedTexts.removeFirst()
                    saveGeneratedTexts()
                    isLoading = false
                } else {
                    generatedText = "No generated text found."
                }
            case .failure(let error):
                generatedText = "Error: \(error.localizedDescription)"
            }
        }
    }
    func saveGeneratedTexts() {
        // You can use UserDefaults, Core Data, or any other storage mechanism here
        // For simplicity, let's use UserDefaults as an example:
        UserDefaults.standard.set(messageTemp, forKey: "messageTemp")
        UserDefaults.standard.set(storedTexts, forKey: "generatedTexts")
    }
}

struct BoxTextView: View {
    var iconName: String
    var text: String
    @Binding var message: String
    
    var body: some View {
        Button(action: {
            message = text
        }) {
            ZStack {
                Color(UIColor.systemGray5)
                    .cornerRadius(10)
                
                HStack {
                    Image(systemName: iconName)
                        .foregroundColor(.gray)
                        .font(.title)
                        .padding(.leading, 30)
                        .padding(.trailing, 10)
                    
                    Text(text)
                        .font(.body)
                        .foregroundColor(.gray)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .padding(.trailing, 10)
                    Spacer()
                }
            }
            .frame(height: 80)
        }
    }
}
struct NumberTextCell: View {
    @State private var text: String
    @State private var isEditing = false
    let data: String
    
    init(data: String) {
        self.data = data
        let components = data.components(separatedBy: ": ")
        self._text = State(initialValue: components.last ?? "")
    }
    
    var body: some View {
        let components = data.components(separatedBy: ": ")
        let number = components.first ?? ""
        
        
        HStack(alignment: .top, spacing: 8) {
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 40, height: 40)
                    .cornerRadius(8)
                Text(number)
                    .font(.headline)
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .frame(width: 50, height: 50)
            }.padding(.trailing, 10)
            // Wrap TextField in a Text view with lineLimit(nil)
            
            TextEditor(text: $text)
                .frame(height: 80)
                .font(.system(size: 16, weight: .semibold))
                .background(Color.blue) // Change the background color to your desired color
                .cornerRadius(8).onAppear {
                    print(data)
                }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
}

struct GenerateGoalView_Previews: PreviewProvider {
    static var previews: some View {
        GenerateGoalView(isFullScreenPresented: .constant(true))
    }
}
