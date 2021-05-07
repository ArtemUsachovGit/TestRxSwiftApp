//
//  PostsViewModel.swift
//  TestRxApp
//
//  Created by Artem Usachov on 05.05.2021.
//

import Foundation
import RxSwift
import RxRelay
import Alamofire

final class PostsViewModel {
    
    enum Mode: Int {
        case posts
        case favorites
    }
    
    private let bag = DisposeBag()
    
    let posts = BehaviorRelay<[Post]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let selectedMode = PublishRelay<Mode>()
    let searchQuery = PublishRelay<String>()

    private var allPosts: [Post] = []
    private var mode: Mode = .posts
    private var favPosts = Set<Post>() //ids of fav posts
    
    private static let fileName = "posts"
    
    private let dataManager: DataManager
    private let authManager: AuthManager
    
    init(dataManager: DataManager, authManager: AuthManager) {
        
        self.authManager = authManager
        self.dataManager = dataManager
        
        selectedMode
            .subscribe(onNext: { [unowned self] mode in
                self.mode = mode
                switch mode {
                case .favorites:
                    posts.accept(Array(favPosts))
                case .posts:
                    posts.accept(allPosts)
                }
        })
        .disposed(by: bag)
        
        searchQuery
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] userInput in
                let source = self.mode == .posts ? allPosts : Array(favPosts)
                if userInput.isEmpty {//in case user cancel or clear the search field
                    posts.accept(source)
                    return
                }
                let filteredPosts = source.filter { $0.title.lowercased().contains(userInput.lowercased()) }
                posts.accept(filteredPosts)
            })
            .disposed(by: bag)
    }
    
    func selected(postAt index: Int) {
        guard self.mode != .favorites else { return }
        let selectedPost = posts.value[index]
        favPosts.insert(selectedPost)
    }
    
    func logout() {
        authManager.logout()
    }
    
    func loadPosts() {
        isLoading.accept(true)
        AF.request("https://jsonplaceholder.typicode.com/posts").responseJSON { [weak self] response in
            self?.isLoading.accept(false)
            switch response.result {
            case .success(let value):
                do {
                    let data = try JSONSerialization.data(withJSONObject: value)
                    let posts = try JSONDecoder().decode([Post].self, from: data)
                    try self?.dataManager.saveData(data, filename: PostsViewModel.fileName)
                    self?.setupInitialData(posts)
                } catch {
                    self?.loadLocalPosts()
                }
            case .failure(let error):
                if error.responseCode != 500 {
                    self?.loadLocalPosts()
                }
            }
        }
    }
}

private extension PostsViewModel {
    
    func setupInitialData(_ posts: [Post]) {
        self.allPosts = posts
        self.posts.accept(posts)
    }
    
    func loadLocalPosts() {
        if let postsData = dataManager.loadData(path: PostsViewModel.fileName),
           let posts = try? JSONDecoder().decode([Post].self, from: postsData) {
            self.setupInitialData(posts)
        }
    }
}
