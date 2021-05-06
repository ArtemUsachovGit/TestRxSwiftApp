//
//  World.swift
//  TestRxApp
//
//  Created by Artem Usachov on 06.05.2021.
//

import Foundation

struct World {
    var authManager: AutManager
}

var Current = World (
    authManager: AutManager()
)
