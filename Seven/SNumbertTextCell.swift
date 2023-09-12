//
//  SNumbertTextCell.swift
//  Seven
//
//  Created by Hubert Le on 9/11/23.
//

import SwiftUI

struct SNumbertTextCell: View {
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
                .frame(height: 100)
                .font(.system(size: 16, weight: .semibold))
                .background(Color.blue) // Change the background color to your desired color
                .cornerRadius(10)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
    
}

struct SNumbertTextCell_Previews: PreviewProvider {
    static var previews: some View {
        SNumbertTextCell(data: "1: Generating long and coherent text is an important but challenging task, particularly for open-ended language generation tasks such as story generation. Despite the success in modeling intra-sentence coherence, existing generation models.")
    }
}
