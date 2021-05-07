//
//  Post.swift
//  TestRxApp
//
//  Created by Artem Usachov on 05.05.2021.
//

import Foundation

struct Post: Codable, Hashable {
    
    let userId: Int
    let id: Int
    let title: String
    let body: String
    
}
