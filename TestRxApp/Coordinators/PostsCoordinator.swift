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
        let postsManager = Current.diContainer.resolve(service: PostsManager.self)!
        let authManager = Current.diContainer.resolve(service: AuthManager.self)!
        let networking = Current.diContainer.resolve(service: Networking.self)!
        
        let viewModel = PostsViewModel(authManager: authManager,
                                       networking: networking,
                                       postsManager: postsManager)
        vc.viewModel = viewModel
        vc.coordinator = self
        self.navigationController.setViewControllers([vc], animated: true)
    }
    
    func showDetails(for post: Post) {
        let postDetailsCoordinator = PostsDetailsCoordinator(navigationController: navigationController,
                                                             parent: self,
                                                             post: post)
        childCoordinators.append(postDetailsCoordinator)
        postDetailsCoordinator.start()
    }
    
    func doLogout() {
        parent?.logout()
    }
    
}
