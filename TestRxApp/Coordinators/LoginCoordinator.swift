//
//  LoginCoordinator.swift
//  TestRxApp
//
//  Created by Artem Usachov on 06.05.2021.
//

import UIKit

class LoginCoordinator: NavigationCoordinator {
    
    typealias Storyboard = R.storyboard

    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    weak var parentCoordinator: Coordinator?
    
    private var parent: AppCoordinator? {
        parentCoordinator as? AppCoordinator
    }
    
    init(navigationController: UINavigationController, parent: Coordinator? = nil) {
        self.navigationController = navigationController
        self.parentCoordinator = parent
    }
    
    func start() {
        guard let loginVC = Storyboard.main.loginController() else { return }
        loginVC.coordinator = self
        navigationController.setViewControllers([loginVC], animated: true)
    }
    
    func navigateToPost() {
        parent?.showPosts()
    }
    
    func didFinishLogin() {
        parentCoordinator?.childDidFinish(self)
    }

}
