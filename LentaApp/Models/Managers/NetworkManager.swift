//
//  NetworkManager.swift
//  LentaApp
//
//  Created by Сергеев Александр on 22.02.2022.
//

import Foundation

protocol NetworkManagerProtocol {
    static var shared: NetworkManagerProtocol { get }
    func fetchData(page: Int, perPage: Int, completion: @escaping ([Photo]) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    static let shared: NetworkManagerProtocol = NetworkManager()
    
    static let apiKey = "2rLiMzqzLQYbNWMN1gmfp9bOYLHbuTBgru3m5dTil7w"
    static private var apiUrl: String {
        return "https://api.unsplash.com/photos/?client_id=\(apiKey)"
    }

    func fetchData(page: Int, perPage: Int, completion: @escaping ([Photo]) -> Void) {
        guard let URL = URL(string: "\(NetworkManager.apiUrl)&page=\(page)&per_page=\(perPage)") else { return }
        
        let task = URLSession.shared.dataTask(with: URL) { (data, _, _) in
            guard
                let data = data,
                let decodeData = try? JSONDecoder().decode([Photo].self, from: data)
                else { return }
            
            completion(decodeData)
        }
        
        task.resume()
    }
}
