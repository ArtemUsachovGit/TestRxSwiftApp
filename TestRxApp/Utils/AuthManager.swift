//
//  AuthManager.swift
//  TestRxApp
//
//  Created by Artem Usachov on 06.05.2021.
//

import Foundation

class AutManager {
    
    private var user = User()
    
    var isLoggedIn: Bool {
        user.hasCredentials
    }
    
    func logout() {
        user.email = ""
        user.password = ""
    }
}
