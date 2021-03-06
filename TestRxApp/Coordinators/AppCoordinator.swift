//
//  AppCoordinator.swift
//  TestRxApp
//
//  Created by Artem Usachov on 06.05.2021.
//

import Foundation
import UIKit

class AppCoordinator: NavigationCoordinator {
    
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    //Dependency
    var authManager: AuthManager!
    
    init(navigationController: UINavigationController, authManager: AuthManager) {
        self.authManager = authManager
        self.navigationController = navigationController
    }
    
    func start() {
        //for handling back button press
        if authManager.isLoggedIn {
            showPosts()
        } else {
            showLogin()
        }
    }
    
    func showPosts() {
        let postsCoord = PostsCoordinator(navigationController: navigationController,
                                          parent: self)
        childCoordinators.append(postsCoord)
        postsCoord.start()
    }
    
    func showLogin() {
        let loginCoord = LoginCoordinator(navigationController: navigationController,
                                          parent: self)
        childCoordinators.append(loginCoord)
        loginCoord.start()
    }
    
    func logout() {
        childCoordinators.removeAll()
        showLogin()
    }

}
