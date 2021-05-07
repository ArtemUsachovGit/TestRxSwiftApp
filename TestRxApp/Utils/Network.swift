//
//  Network.swift
//  TestRxApp
//
//  Created by Artem Usachov on 07.05.2021.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case parsing
    case server
    case unknown
}

struct Networking {
    
    private let baseUrl = "https://jsonplaceholder.typicode.com/"
    
    enum RequestPath: String {
        case posts
    }
    
    private func makeUrl(for path: RequestPath) -> String {
        baseUrl + path.rawValue
    }
    
    func getPosts(completion: @escaping (Swift.Result<[Post], NetworkError>) -> Void) {
        let url = makeUrl(for: .posts)
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                do {
                    let data = try JSONSerialization.data(withJSONObject: value)
                    let posts = try JSONDecoder().decode([Post].self, from: data)
                    completion(.success(posts))
                } catch {
                    completion(.failure(.parsing))
                }
            case .failure(let error):
                if error.responseCode == 500 {
                    completion(.failure(.server))
                } else {
                    completion(.failure(.unknown))
                }
            }
        }
    }
}
