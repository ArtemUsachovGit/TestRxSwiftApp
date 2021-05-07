//
//  DIContainer.swift
//  TestRxApp
//
//  Created by Artem Usachov on 07.05.2021.
//

import Foundation
import Swinject

class DIContainer {
    
    private let container = Container()
    
    func resolve<T>(service: T.Type, name: String? = nil) -> T? {
        return container.resolve(service, name: name)
    }
    
    func register<T>(name: String? = nil, value: T) {
        container.register(type(of: value), name: name) { _ in value }
    }
    
    init() {
        container
            .register(AuthManager.self, factory: { _ in  AuthManager() })
            .inObjectScope(.container)
        
        container
            .register(FileManager.self) { _ in FileManager.default }
        
        container
            .register(DataManager.self, factory: { r in
                let fileManager = r.resolve(FileManager.self)!
                return FileDataManagerImpl(fileManager: fileManager)
            })
            .inObjectScope(.container)
        
    }
}
