//
//  AddRegistrationViewModel.swift
//  HotelBooking
//
//  Created by Barış Dilekçi on 24.08.2025.
//

import Foundation

// MARK: - View Model
protocol AddRegistrationViewModelProtocol: AnyObject {
    var firstName: String { get set }
    var lastName: String { get set }
    var email: String { get set }
    var checkInDate: Date { get set }
    var checkOutDate: Date { get set }
    var numberOfAdults: Double { get set }
    var numberOfChildren: Double { get set }
    var hasWifi: Bool { get set }
    var roomType: RoomType? { get set }
    
    var checkInDateFormatted: String { get }
    var checkOutDateFormatted: String { get }
    var numberOfAdultsText: String { get }
    var numberOfChildrenText: String { get }
    var roomTypeDisplayText: String { get }
    var minimumCheckInDate: Date { get }
    var minimumCheckOutDate: Date { get }
    var checkInDateLabelIndexPath : IndexPath { get }
    var checkInDatePickerIndexPath : IndexPath { get }
    var checkOutDateLabelIndexPath : IndexPath { get }
    var checkOutDatePickerIndexPath : IndexPath { get }
    
    var currentRegistration: Registration? { get }
    
    func updateCheckInDate(_ date: Date)
    func validateRegistration() -> ValidationResult
    func validateEmail() -> ValidationResult
}


final class AddRegistrationViewModel: AddRegistrationViewModelProtocol {
    var checkInDateLabelIndexPath: IndexPath {
        return IndexPath(row: Constants.DateRows.checkInLabel, section: Constants.TableSections.dates)
    }
    
    var checkInDatePickerIndexPath: IndexPath {
        return IndexPath(row: Constants.DateRows.checkInPicker, section: Constants.TableSections.dates)
    }
    
    var checkOutDateLabelIndexPath: IndexPath {
        return IndexPath(row: Constants.DateRows.checkOutLabel, section: Constants.TableSections.dates)
    }
    
    var checkOutDatePickerIndexPath: IndexPath {
        return IndexPath(row: Constants.DateRows.checkOutPicker, section: Constants.TableSections.dates)
    }
    
    
    //MARK: Properties
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var checkInDate: Date = Date()
    var checkOutDate: Date = Date()
    var numberOfAdults: Double = Constants.GuestLimits.minAdults
    var numberOfChildren: Double = Constants.GuestLimits.minChildren
    var hasWifi: Bool = false
    var roomType: RoomType?
    
    
    //MARK: Dependencies
    private let validationHelper : ValidationHelper
    private let dateHelper : DateHelper
    
    // MARK: - Computed Properties
    var checkInDateFormatted: String {
        return dateHelper.formatDateForDisplay(checkInDate)
    }
    
    var checkOutDateFormatted: String {
        return dateHelper.formatDateForDisplay(checkOutDate)
    }
    
    var numberOfAdultsText: String {
        return "\(Int(numberOfAdults))"
    }
    
    var numberOfChildrenText: String {
        return "\(Int(numberOfChildren))"
    }
    
    var roomTypeDisplayText: String {
        return roomType?.name ?? NSLocalizedString(Constants.LocalizationKeys.noRoomSelected, comment: "")
    }
    
    var minimumCheckInDate: Date {
        return dateHelper.midnightToday()
    }
    
    var minimumCheckOutDate: Date {
        return dateHelper.minimumCheckOutDate(for: checkInDate)
    }
    
    var currentRegistration: Registration? {
         guard let roomType = roomType else { return nil }
         
         return Registration(
             firstName: firstName.trimmingCharacters(in: .whitespacesAndNewlines),
             lastName: lastName.trimmingCharacters(in: .whitespacesAndNewlines),
             emailAddress: email.trimmingCharacters(in: .whitespacesAndNewlines),
             chechInDate: checkInDate,
             checkOutDate: checkOutDate,
             numberOfAdults: Int(numberOfAdults),
             numberOfChildren: Int(numberOfChildren),
             roomType: roomType,
             wifi: hasWifi
         )
     }
    // MARK: - Initialization
    init(validationHelper : ValidationHelper , dateHelper : DateHelper) {
        self.validationHelper = validationHelper
        self.dateHelper = dateHelper
    }
    
    // MARK: - Public Methods
      func updateCheckInDate(_ date: Date) {
          checkInDate = date
          if checkOutDate <= checkInDate {
              checkOutDate = dateHelper.minimumCheckOutDate(for: checkInDate)
          }
      }
      
      func validateRegistration() -> ValidationResult {
          return validationHelper.validateRegistration(
              firstName: firstName,
              lastName: lastName,
              email: email,
              checkInDate: checkInDate,
              checkOutDate: checkOutDate,
              roomType: roomType
          )
      }
      
      func validateEmail() -> ValidationResult {
          return validationHelper.validateEmail(email)
      }
      
      // MARK: - Private Methods
      private func setupInitialValues() {
          checkInDate = dateHelper.defaultCheckInDate()
          checkOutDate = dateHelper.defaultCheckOutDate()
      }
}
