//
//  Date+Extensions.swift
//  NoteTakingSwiftData
//
//  Created by Serhan Khan on 20/10/2024.
//

import Foundation

extension Date {
    // DateFormatter function to format the date
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // Choose the desired date format
        return formatter.string(from: self)
    }
}
