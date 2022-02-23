//
//  PhotoCell.swift
//  LentaApp
//
//  Created by Сергеев Александр on 22.02.2022.
//

import UIKit

class PhotoCell: UITableViewCell {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var titlePhoto: UILabel!
    
    private var imageCache = NSCache<NSString, UIImage>()
    
    func configureCell(photo: Photo) {
        guard let smallImagePath = photo.urls?["small"] else { return }
        guard let URL = URL(string: smallImagePath) else { return }
        
        let urlAbsolutely = URL.absoluteString
        
        if let cachedImage = self.imageCache.object(forKey: urlAbsolutely as NSString) {
            DispatchQueue.main.async {
                self.photo.image = cachedImage
            }
        } else {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: URL) {
                    guard let image = UIImage(data: imageData) else { return }
                    
                    self.imageCache.setObject(image, forKey: urlAbsolutely as NSString)
                    
                    DispatchQueue.main.async {
                        self.photo.image = image
                    }
                }
            }
        }
        
        titlePhoto.text = photo.description ?? ""
        
        selectionStyle = .none
    }
}
