//
//  PostDetailsViewModel.swift
//  TestRxApp
//
//  Created by Artem Usachov on 07.05.2021.
//

import Foundation
import RxRelay
import RxSwift

class PostDetailsViewModel {

    let post: Post
    let networking: Networking
    
    let comments = BehaviorRelay<[Comment]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    init(post: Post, networking: Networking) {
        self.post = post
        self.networking = networking
    }
        
    func loadComments() {
        isLoading.accept(true)
        networking.getComments(for: post.id) { [weak self] result in
            self?.isLoading.accept(false)
            switch result {
            case .success(let postComments):
                self?.comments.accept(postComments)
            case .failure(let error):
                print("Handle error of comments loading - \(error)")
            }
        }
    }
}
