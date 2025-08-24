//
//  DateHelper.swift
//  HotelBooking
//
//  Created by Barış Dilekçi on 24.08.2025.
//

import Foundation

// MARK: - Date Helper
struct DateHelper {
    
    // MARK: - Date Formatter
    private  let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = Constants.DateConfiguration.dateStyle
        return formatter
    }()
    
    // MARK: - Format Date for Display
    func formatDateForDisplay(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    // MARK: - Get Midnight Today
     func midnightToday() -> Date {
        return Calendar.current.startOfDay(for: Date())
    }
    
    // MARK: - Add Days to Date
     func addDays(_ days: Int, to date: Date) -> Date {
        let timeInterval = TimeInterval(days) * Constants.DateConfiguration.secondsInDay
        return date.addingTimeInterval(timeInterval)
    }
    
    // MARK: - Get Minimum Check-out Date
     func minimumCheckOutDate(for checkInDate: Date) -> Date {
        return addDays(1, to: checkInDate)
    }
    
    // MARK: - Validate Date Range
     func isValidDateRange(checkIn: Date, checkOut: Date) -> Bool {
        return checkOut > checkIn
    }
    
    // MARK: - Get Default Check-in Date
     func defaultCheckInDate() -> Date {
        return midnightToday()
    }
    
    // MARK: - Get Default Check-out Date
     func defaultCheckOutDate() -> Date {
        return addDays(1, to: midnightToday())
    }
}
