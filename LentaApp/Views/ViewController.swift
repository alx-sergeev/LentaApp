//
//  ViewController.swift
//  LentaApp
//
//  Created by Сергеев Александр on 22.02.2022.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var myTableView: UITableView!
    
    // MARK: - Properties
    private let cellName = "photoCell"
    private let networkManager: NetworkManagerProtocol = NetworkManager.shared
    private var photos: [Photo]! = []
    private var numPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        
        let _ = networkManager.fetchData(page: numPage, perPage: 10) { [weak self] decodeData in
            self?.photos = decodeData
            
            DispatchQueue.main.async {
                self?.myTableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! PhotoCell
        let row = indexPath.row
        
        if row == photos.count - 1 {
            numPage += 1
            
            let _ = networkManager.fetchData(page: numPage, perPage: 10) { [weak self] decodeData in
                let _ = decodeData.map { self?.photos.append($0) }
                
                DispatchQueue.main.async {
                    self?.myTableView.reloadData()
                }
            }
        }
        
        DispatchQueue.global().async {
            guard let smallImagePath = self.photos[row].urls?["small"] else { return }
            guard let URL = URL(string: smallImagePath) else { return }
            guard let imageData = try? Data(contentsOf: URL) else { return }
        
            DispatchQueue.main.async {
                cell.photo.image = UIImage(data: imageData)
            }
        }
        
        cell.titlePhoto.text = photos[row].description ?? ""
        
        return cell
    }
}
