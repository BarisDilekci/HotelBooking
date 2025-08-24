//
//  Constant.swift
//  HotelBooking
//
//  Created by Barış Dilekçi on 24.08.2025.
//

import Foundation
import UIKit

// MARK: - App Constants
struct Constants {
    
    // MARK: - UI Constants
    struct UI {
        static let defaultRowHeight: CGFloat = 44.0
        static let datePickerHeight: CGFloat = 216.0
        static let animationDuration: TimeInterval = 0.3
        static let cornerRadius: CGFloat = 8.0
        static let borderWidth: CGFloat = 1.0
        static let padding: CGFloat = 16.0
    }
    
    // MARK: - Date Constants
    struct DateConfiguration {
        static let secondsInDay: Double = 24 * 60 * 60
        static let dateFormat = "dd/MM/yyyy"
        static let dateStyle: DateFormatter.Style = .medium
    }
    
    // MARK: - Guest Limits
    struct GuestLimits {
        static let maxAdults: Double = 10
        static let minAdults: Double = 1
        static let maxChildren: Double = 8
        static let minChildren: Double = 0
        static let stepValue: Double = 1
    }
    
    // MARK: - Section Indices
    struct TableSections {
        static let personalInfo = 0
        static let dates = 1
        static let guests = 2
        static let amenities = 3
        static let roomType = 4
    }
    
    // MARK: - Row Indices for Date Section
    struct DateRows {
        static let checkInLabel = 0
        static let checkInPicker = 1
        static let checkOutLabel = 2
        static let checkOutPicker = 3
    }
    
    // MARK: - Segue Identifiers
    struct Segues {
        static let selectRoomType = "selectRoomType"
        static let saveRegistration = "unwindToRegistrationList"
    }
    
    // MARK: - Localization Keys
    struct LocalizationKeys {
        static let noRoomSelected = "Select Room"
        static let adults = "Adults"
        static let children = "Children"
        static let checkIn = "Check in"
        static let checkOut = "check_out"
        static let cancel = "cancel"
        static let save = "Save"
        static let wifi = "wifi"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let email = "email"
    }
    
    // MARK: - Error Messages
    struct ErrorMessages {
        static let invalidEmail = "Invalid Email"
        static let missingFirstName = "Missing first name"
        static let missingLastName = "Missing last name"
        static let invalidDateRange = "invalid date range"
        static let noRoomSelected = "No selected room"
    }
}
