//
//  ValidationHelper.swift
//  HotelBooking
//
//  Created by Barış Dilekçi on 24.08.2025.
//

import Foundation

// MARK: - Registration Validation Result
enum ValidationResult {
    case valid
    case invalid(String)
}

// MARK: - Validation Helper
struct ValidationHelper {
    
    // MARK: - Email Validation
     func validateEmail(_ email: String?) -> ValidationResult {
        guard let email = email, !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return .invalid(Constants.ErrorMessages.invalidEmail)
        }
        
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if emailPredicate.evaluate(with: email) {
            return .valid
        } else {
            return .invalid(Constants.ErrorMessages.invalidEmail)
        }
    }
    
    // MARK: - Name Validation
     func validateFirstName(_ firstName: String?) -> ValidationResult {
        guard let firstName = firstName, !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return .invalid(Constants.ErrorMessages.missingFirstName)
        }
        return .valid
    }
    
     func validateLastName(_ lastName: String?) -> ValidationResult {
        guard let lastName = lastName, !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return .invalid(Constants.ErrorMessages.missingLastName)
        }
        return .valid
    }
    
    // MARK: - Date Range Validation
     func validateDateRange(checkIn: Date, checkOut: Date) -> ValidationResult {
        if checkOut <= checkIn {
            return .invalid(Constants.ErrorMessages.invalidDateRange)
        }
        return .valid
    }
    
    // MARK: - Room Type Validation
     func validateRoomType(_ roomType: RoomType?) -> ValidationResult {
        guard roomType != nil else {
            return .invalid(Constants.ErrorMessages.noRoomSelected)
        }
        return .valid
    }
    
    // MARK: - Complete Registration Validation
     func validateRegistration(
        firstName: String?,
        lastName: String?,
        email: String?,
        checkInDate: Date,
        checkOutDate: Date,
        roomType: RoomType?
    ) -> ValidationResult {
        
        let validations = [
            validateFirstName(firstName),
            validateLastName(lastName),
            validateEmail(email),
            validateDateRange(checkIn: checkInDate, checkOut: checkOutDate),
            validateRoomType(roomType)
        ]
        
        for validation in validations {
            if case .invalid(let message) = validation {
                return .invalid(message)
            }
        }
        
        return .valid
    }
}
