//
//  UserDefaultsService.swift
//  TodoList
//
//  Created by Валентин on 05.09.2025.
//

import Foundation

protocol UserDefaultsServiceProtocol {
    func isNotFirstLaunch() -> Bool
    func markAsNotFirstLaunch()
}

final class UserDefaultsService: UserDefaultsServiceProtocol {
    private let userDefaults = UserDefaults.standard
    private let notFirstLaunchKey = "isNotFirstLaunch"
    
    func isNotFirstLaunch() -> Bool {
        return userDefaults.bool(forKey: notFirstLaunchKey)
    }
    
    func markAsNotFirstLaunch() {
        userDefaults.set(true, forKey: notFirstLaunchKey)
    }

}
