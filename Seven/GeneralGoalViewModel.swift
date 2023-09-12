//
//  GeneralGoalViewModel.swift
//  Seven
//
//  Created by Hubert Le on 8/20/23.
//

import Foundation

class GenerateGoalViewModel: ObservableObject {
    @Published var promptText: String = ""
    @Published var generatedText: String = ""
    @Published var message: String = ""
    @Published var messageTemp: String = ""
    @Published var storedTexts: [String] = []
    @Published var isScrollViewVisible: Bool = false
    @Published var offset: CGFloat = 0
}

class DateUtility {
    static let shared = DateUtility()
    private let dateFormatter: DateFormatter

    private init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }

    func getCurrentFormattedDate() -> String {
        let date = Date()
        return dateFormatter.string(from: date)
    }

    func getFormattedDate(for index: Int) -> String {
        let date = Calendar.current.date(byAdding: .day, value: index, to: Date()) ?? Date()
        return dateFormatter.string(from: date)
    }
}
