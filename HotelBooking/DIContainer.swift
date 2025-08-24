//
//  DIContainer.swift
//  HotelBooking
//
//  Created by Barış Dilekçi on 24.08.2025.
//

import Foundation

// MARK: - Dependency Container
protocol DIContainerProtocol {
    func resolve<T>(_ type: T.Type) -> T
}

final class DIContainer: DIContainerProtocol {
    private var services: [String: Any] = [:]
    
    init() {
        registerDependencies()
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        guard let service = services[key] as? T else {
            fatalError("Service not registered: \(key)")
        }
        return service
    }
    
    private func registerDependencies() {
        let validationHelper = ValidationHelper()
        let dateHelper = DateHelper()
        
        services[String(describing: ValidationHelper.self)] = validationHelper
        services[String(describing: DateHelper.self)] = dateHelper
        services[String(describing: AddRegistrationViewModelProtocol.self)] = AddRegistrationViewModel(
            validationHelper: validationHelper,
            dateHelper: dateHelper
        )
    }
}
