//
//  Comment.swift
//  TestRxApp
//
//  Created by Artem Usachov on 05.05.2021.
//

import Foundation

struct Comment: Codable {
    
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
    
}
