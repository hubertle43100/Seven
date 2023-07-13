//
//  File.swift
//  TinyHabits
//
//  Created by Hubert Le on 10/3/22.
//

import Foundation
import SwiftUI

struct ColorDefaults {
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
}
