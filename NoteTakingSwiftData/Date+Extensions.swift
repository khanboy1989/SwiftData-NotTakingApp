//
//  Date+Extensions.swift
//  NoteTakingSwiftData
//
//  Created by Serhan Khan on 20/10/2024.
//

import Foundation

extension Date {
    // DateFormatter function to format the date with time
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // Format for the date
        formatter.timeStyle = .short  // Format for the time (hour and minute)
        return formatter.string(from: self)
    }
}
