//
//  generateGoals.swift
//  TinyHabits
//
//  Created by Hubert Le on 7/16/23.
//

import SwiftUI
import OpenAI

struct generateGoals: View {
    @State private var promptText: String = ""
    @State private var generatedText: String = ""
    @State private var longText: String = ""
    @State private var storedTexts: [String] = []
    @State private var tempStoredTexts: [String] = []
    private let openAI = OpenAI(apiToken: "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") // Replace with your OpenAI API key
    

    var body: some View {
        VStack {
            TextField("Enter your prompt here", text: $promptText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Generate Text") {
                //generateText()
                Task {
                    await fetchGeneratedText()
                }
                tempStoredTexts = ["Day 1: Schedule 30 minutes of freetime in the morning.",
                                   "Day 2: Take a break from work for 15 minutes.",
                                   "Day 3: Spend an hour outside in nature.",
                                   "Day 4: Make time for a hobby.",
                                  " Day 5: Take a break from technology for an hour.",
                                   "Day 6: Schedule a 30 minute nap.",
                                   "Day 7: Spend an hour with friends or family."]
            }.foregroundColor(.black)
                .padding()
            
            Text("Generated Text:")
                .font(.headline)
                .padding(.top)
            
            ScrollView {
                // Display each element in a separate cell with a gray background
                ForEach(tempStoredTexts, id: \.self) { goalText in
                    Text(goalText)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                ForEach(storedTexts, id: \.self) { goalText in
                    Text(goalText)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
            }
            
        }
        .padding()
    }
    func fetchGeneratedText() async {
        print("testing...")
        let query = CompletionsQuery(model: .textDavinci_003, prompt: "Generate specific goals for 7 days for this goal and one sentence for each day for this goal and make it doable: I want grow 2 inches", temperature: 0, maxTokens: 100, topP: 1, frequencyPenalty: 0, presencePenalty: 0, stop: ["\\n"])
        openAI.completions(query: query) { result in
            //Handle result here
        }
        //or
        do {
            let result = try await openAI.completions(query: query)
            if let generatedChoice = result.choices.first {
                print("BEFORE HOME: \(generatedText)")
                generatedText = generatedChoice.text // Update the generatedText property
                let modifiedText = generatedText.replacingOccurrences(of: "\n\n", with: "")
                let daysArray = modifiedText.components(separatedBy: "Day ")
                let trimmedArray = daysArray.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                print("HOME:\(trimmedArray)")
                storedTexts.append(contentsOf: trimmedArray)
                storedTexts.removeFirst()
                print("HOME:\(storedTexts)")
                saveGeneratedTexts()
                print("SLEEP: \(generatedText)")
            } else {
                generatedText = "No generated text found."
            }
        } catch {
            generatedText = "Error: \(error)"
        }
        print("done!")
    }
    func saveGeneratedTexts() {
        // You can use UserDefaults, Core Data, or any other storage mechanism here
        // For simplicity, let's use UserDefaults as an example:
        
        UserDefaults.standard.set(storedTexts, forKey: "generatedTexts")
    }
}

struct generateGoals_Previews: PreviewProvider {
    static var previews: some View {
        generateGoals()
    }
}
