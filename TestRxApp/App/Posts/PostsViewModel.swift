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
    private var favPosts: Set<Post> //ids of fav posts
    
    private let authManager: AuthManager
    private let networking: Networking
    private let postsManager: PostsManager
    
    init(authManager: AuthManager, networking: Networking, postsManager: PostsManager) {
        
        self.networking = networking
        self.authManager = authManager
        self.postsManager = postsManager
        
        self.favPosts = Set(postsManager.loadLocalPosts(.favPosts) ?? [])
        
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
        postsManager.save(Array(favPosts), fileName: .favPosts)
    }
    
    func logout() {
        authManager.logout()
    }
    
    func loadPosts() {
        isLoading.accept(true)
        networking.getPosts { [weak self] result in
            self?.isLoading.accept(false)
            switch result {
            case .success(let posts):
                self?.setupInitialData(posts)
                self?.postsManager.save(posts, fileName: .allPosts)
            case .failure(let error):
                switch error {
                case .parsing, .unknown:
                    let posts = self?.postsManager.loadLocalPosts(.allPosts) ?? []
                    self?.setupInitialData(posts)
                case .server:
                    //show server error
                    print("Server retruning error on posts request")
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
}
