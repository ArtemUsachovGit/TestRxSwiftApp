//
//  LoginViewController.swift
//  TestRxApp
//
//  Created by Artem Usachov on 05.05.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController, Coordinatable {
    
    weak var coordinator: LoginCoordinator?

    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var loginButton: UIButton!
    
    private let bag = DisposeBag()
    private let viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.title = "Login"
        makeBindings()
    }
    
    @IBAction func login() {
        view.endEditing(true)
        viewModel.createUser()
        coordinator?.navigateToPost()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.didFinishLogin()
    }
}

private extension LoginViewController {
    func makeBindings() {
        
        emailTextField.rx
            .text
            .orEmpty
            .bind(to: viewModel.email)
            .disposed(by: bag)

        passwordTextField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.password)
            .disposed(by: bag)
        
        viewModel
            .formIsValid
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: bag)
    }
}
