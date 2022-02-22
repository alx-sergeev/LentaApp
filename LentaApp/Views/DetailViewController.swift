//
//  DetailViewController.swift
//  LentaApp
//
//  Created by Сергеев Александр on 23.02.2022.
//

import UIKit

class DetailViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var detailPhoto: UIImageView!
    @IBOutlet weak var downloadLabel: UILabel!
    
    // MARK: - Properties
    var imageData: Photo!
    private var downloadCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if imageData != nil {
            DispatchQueue.global().async {
                guard let smallImagePath = self.imageData.urls?["small"] else { return }
                guard let URL = URL(string: smallImagePath) else { return }
                guard let imageData = try? Data(contentsOf: URL) else { return }
            
                DispatchQueue.main.async {
                    self.detailPhoto.image = UIImage(data: imageData)
                }
            }
        }
        
        downloadLabel.text = "Количество скачиваний: \(downloadCount)"
    }
}
