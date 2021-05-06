//
//  LoginViewModel.swift
//  TestRxApp
//
//  Created by Artem Usachov on 05.05.2021.
//

import Foundation
import RxSwift
import RxRelay

final class LoginViewModel {
    
    private var disposeBag = DisposeBag()
    
    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    
    let formIsValid: Observable<Bool>
    
    init() {
        formIsValid = Observable.combineLatest(self.email.asObservable(), self.password.asObservable()) { email, password in
            return email.isEmailValid() && password.isPasswordValid()
        }
    }
    
    func createUser() {
        var user = User()
        user.email = email.value
        user.password = password.value
    }
}
