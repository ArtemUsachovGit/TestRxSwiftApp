//
//  User.swift
//  TestRxApp
//
//  Created by Artem Usachov on 06.05.2021.
//

import Foundation

struct User {
    @UserCredentials(key: .userEmail)
    var email: String?
    
    @UserCredentials(key: .userPassword)
    var password: String?
    
    var hasCredentials: Bool {
        password?.isEmpty == false && email?.isEmpty == false
    }
}
