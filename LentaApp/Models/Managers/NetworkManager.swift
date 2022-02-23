//
//  NetworkManager.swift
//  LentaApp
//
//  Created by Сергеев Александр on 22.02.2022.
//

import Foundation
import UIKit

protocol NetworkManagerProtocol {
    static var shared: NetworkManagerProtocol { get }
    func fetchData(page: Int, perPage: Int, completion: @escaping ([Photo]) -> Void)
    func fetchItem(path: String, completion: @escaping (UIImage) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    static let shared: NetworkManagerProtocol = NetworkManager()
    
    static let apiKey = "2rLiMzqzLQYbNWMN1gmfp9bOYLHbuTBgru3m5dTil7w"
    static private var apiUrl: String {
        return "https://api.unsplash.com/photos/?client_id=\(apiKey)"
    }
    private var imageCache = NSCache<NSString, UIImage>()

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
    
    func fetchItem(path: String, completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: path) else { return }

        let urlAbsolutely = url.absoluteString
        if let cachedImage = imageCache.object(forKey: urlAbsolutely as NSString) {
            completion(cachedImage)
        } else {
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: url) else { return }
                guard let image = UIImage(data: imageData) else { return }
                
                self.imageCache.setObject(image, forKey: urlAbsolutely as NSString)
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
}
