//
//  PostsCoordinator.swift
//  TestRxApp
//
//  Created by Artem Usachov on 06.05.2021.
//

import UIKit

class PostsCoordinator: NavigationCoordinator {
    
    typealias Storyboard = R.storyboard
    
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    weak var parentCoordinator: Coordinator?
    
    private var parent: AppCoordinator? {
        return parentCoordinator as? AppCoordinator
    }
    
    init(navigationController: UINavigationController, parent: Coordinator? = nil) {
        self.navigationController = navigationController
        self.parentCoordinator = parent
    }
    
    func start() {
        guard let vc = Storyboard.main.postsController() else { return }
        
        //Dependencies
        let dataManager = Current.diContainer.resolve(service: DataManager.self)!
        let authManager = Current.diContainer.resolve(service: AuthManager.self)!
        
        let viewModel = PostsViewModel(dataManager: dataManager,
                                       authManager: authManager)
        vc.viewModel = viewModel
        vc.coordinator = self
        self.navigationController.setViewControllers([vc], animated: true)
    }
    
    func doLogout() {
        parent?.logout()
    }
    
}
