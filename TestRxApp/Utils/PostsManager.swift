//
//  PostsManager.swift
//  TestRxApp
//
//  Created by Artem Usachov on 07.05.2021.
//

import Foundation

struct PostsManager {
    
    let dataManager: DataManager
    
    enum FileName: String {
        case allPosts
        case favPosts
    }
    
    func loadLocalPosts(_ fileName: FileName) -> [Post]? {
        if let postsData = dataManager.loadData(path: fileName.rawValue),
           let posts = try? JSONDecoder().decode([Post].self, from: postsData) {
            return posts
        }
        return nil
    }
    
    func save(_ posts: [Post], fileName: FileName) {
        do {
            let data = try JSONEncoder().encode(posts)
            try dataManager.saveData(data, filename: fileName.rawValue)
        } catch {
            print(error)
            //handle error of the saving data to disk
        }
    }
}
