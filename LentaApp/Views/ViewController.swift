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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! PhotoCell
        
        cell.titlePhoto.text = "Example text"
        
        DispatchQueue.global().async {
            guard let URL = URL(string: "https://images.unsplash.com/photo-1417325384643-aac51acc9e5d?q=75&fm=jpg&w=400&fit=max") else { return }
            guard let imageData = try? Data(contentsOf: URL) else { return }
        
            DispatchQueue.main.async {
                cell.photo.image = UIImage(data: imageData)
            }
        }
        
        cell.titlePhoto.text = "My description for photo"
        
        return cell
    }
    
    
}
