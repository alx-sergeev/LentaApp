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
    
    func configureCell(photo: Photo) {
        DispatchQueue.global().async {
            guard let smallImagePath = photo.urls?["small"] else { return }
            guard let URL = URL(string: smallImagePath) else { return }
            guard let imageData = try? Data(contentsOf: URL) else { return }
        
            DispatchQueue.main.async {
                self.photo.image = UIImage(data: imageData)
            }
        }
        
        titlePhoto.text = photo.description ?? ""
        
        selectionStyle = .none
    }
}
