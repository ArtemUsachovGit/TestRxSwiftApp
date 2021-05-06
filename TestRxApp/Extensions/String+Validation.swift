//
//  String+Validation.swift
//  TestRxApp
//
//  Created by Artem Usachov on 05.05.2021.
//

import Foundation

extension String {
    func isEmailValid() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isPasswordValid() -> Bool {
        (8...15).contains(self.count)
    }
}
