//
//  PhotoCell.swift
//  LentaApp
//
//  Created by Сергеев Александр on 22.02.2022.
//

import UIKit
import Nuke

class PhotoCell: UITableViewCell {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var titlePhoto: UILabel!
    
    func configureCell(photo: Photo) {
        guard let smallImagePath = photo.urls?["small"] else { return }
        guard let URL = URL(string: smallImagePath) else { return }
        
        Nuke.loadImage(with: URL, into: self.photo)
        
        titlePhoto.text = photo.description ?? ""
        
        selectionStyle = .none
    }
}
