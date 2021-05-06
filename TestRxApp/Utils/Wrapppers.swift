//
//  Wrapppers.swift
//  TestRxApp
//
//  Created by Artem Usachov on 06.05.2021.
//

import Foundation
import SwiftKeychainWrapper

extension KeychainWrapper.Key {
    static let userPassword: KeychainWrapper.Key = "userPassword"
    static let userEmail: KeychainWrapper.Key = "userEmail"
}

@propertyWrapper struct UserCredentials {
    let key: KeychainWrapper.Key
    let storage = KeychainWrapper.standard
    
    var wrappedValue: String? {
        get { storage.string(forKey: key) }
        set { storage[key] = newValue }
    }
}
