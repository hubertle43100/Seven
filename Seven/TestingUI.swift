//
//  TestingUI.swift
//  Seven
//
//  Created by Hubert Le on 8/25/23.
//

import SwiftUI

struct TestingUI: View {
    @State private var dataArray: [String] = ["Number 1: Text 1", "Number 2: Text 2"]

        var body: some View {
            VStack {
                ForEach(0..<dataArray.count, id: \.self) { index in
                    sumberTextCell(data: $dataArray[index])
                }
                Button(action: {
                               saveData() // Call a function to save the array
                           }) {
                               Text("Slave")
                                   .font(.headline)
                                   .foregroundColor(.white)
                                   .padding()
                                   .background(Color.blue)
                                   .cornerRadius(8)
                           }
            }
        }
    private func saveData() {
            // Implement your logic to save the dataArray here
            // For example, you can save it to UserDefaults
            UserDefaults.standard.set(dataArray, forKey: "SavedDataArray")
        }
}
struct sumberTextCell: View {
    @Binding var data: String
    
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
            }.padding(.trailing, 10)
            
            TextField("", text: $data)
                .font(.body)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
}
struct TestingUI_Previews: PreviewProvider {
    static var previews: some View {
        TestingUI()
    }
}
