//
//  Coordinator.swift
//  TestRxApp
//
//  Created by Artem Usachov on 06.05.2021.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var parentCoordinator: Coordinator? { get set }
    
    func start()
    func childDidFinish(_ childCoordinator: Coordinator?)
}

protocol Coordinatable {
    associatedtype SomeCoordinator: Coordinator
    var coordinator: SomeCoordinator? { get set }
}

extension Coordinator {
    func childDidFinish(_ childCoordinator: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === childCoordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

protocol NavigationCoordinator: Coordinator {
    var navigationController: UINavigationController { get set }
}
