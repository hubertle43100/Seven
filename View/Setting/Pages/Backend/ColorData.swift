//
//  ColorData.swift
//  TinyHabits
//
//  Created by Hubert Le on 9/6/22.
//

import Foundation
import SwiftUI

struct ColorData {
    
    private var COLOR_KEY = "COLOR_KEY"
    private var userDefaults = UserDefaults.standard
    
    func saveColor(color: Color) {
        let color = UIColor(color).cgColor
        
        if let components = color.components {
            userDefaults.set(components, forKey: COLOR_KEY)
        }
    }
    
    func loadColor() -> Color {
        guard let array = userDefaults.object(forKey: COLOR_KEY) as? [CGFloat] else { return Color.black }
        
        let color = Color(.sRGB,
                          red: array[0],
                          green: array[1],
                          blue: array[2],
                          opacity: array[3])
    
        return color
    }
    
    func loadForegroundColor() -> Color {
        guard let array = userDefaults.object(forKey: COLOR_KEY) as? [CGFloat] else { return Color.black }
        
        let color = Color(.sRGB,
                          red: array[0],
                          green: array[1] * 0.125,
                          blue: array[2] * 0.25,
                          opacity: array[3] * 0.375)
        
        return color
    }
}
