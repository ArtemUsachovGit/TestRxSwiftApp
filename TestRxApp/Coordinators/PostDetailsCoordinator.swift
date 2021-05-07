//
//  PostDetailsCoordinator.swift
//  TestRxApp
//
//  Created by Artem Usachov on 07.05.2021.
//

import UIKit

class PostsDetailsCoordinator: NavigationCoordinator {
    
    typealias Storyboard = R.storyboard
    
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    weak var parentCoordinator: Coordinator?
    
    let post: Post
    
    private var parent: PostsCoordinator? {
        return parentCoordinator as? PostsCoordinator
    }
    
    init(navigationController: UINavigationController, parent: Coordinator? = nil, post: Post) {
        self.post = post
        self.navigationController = navigationController
        self.parentCoordinator = parent
    }
    
    func start() {
        guard let vc = Storyboard.postDetails.postDetails() else { return }
        
        let networking  = Current.diContainer.resolve(service: Networking.self)!
        
        let viewModel = PostDetailsViewModel(post: post, networking: networking)
        vc.viewModel = viewModel
        
        self.navigationController.pushViewController(vc, animated: true)
    }
}
