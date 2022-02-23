//
//  DetailViewController.swift
//  LentaApp
//
//  Created by Сергеев Александр on 23.02.2022.
//

import UIKit
import Nuke

// MARK: - Protocol DetailViewControllerProtocol
protocol DetailViewControllerProtocol: AnyObject {
    func showInfoDownloadPhoto(date: String)
}

class DetailViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var detailPhoto: UIImageView!
    @IBOutlet weak var downloadLabel: UILabel!
    
    // MARK: - Properties
    private var presenter: DetailViewControllerPresenterProtocol!
    
    var imageData: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = DetailViewControllerPresenter(view: self)
        
        downloadLabel.isHidden = true
        
        if imageData != nil {
            guard
                let smallImagePath = imageData.urls?["small"],
                let URL = URL(string: smallImagePath) else { return }
            
            Nuke.loadImage(with: URL, into: detailPhoto)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let detailPhoto = detailPhoto.image else { return }
        
        UIImageWriteToSavedPhotosAlbum(detailPhoto, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        guard error == nil else {
            let ac = UIAlertController(title: "Ошибка сохранения", message: error!.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
            ac.addAction(okAction)
            
            present(ac, animated: true, completion: nil)
            
            return
        }
        
        presenter?.didSavePhoto()
    }
}

// MARK: - DetailViewControllerProtocol
extension DetailViewController: DetailViewControllerProtocol {
    func showInfoDownloadPhoto(date: String) {
        downloadLabel.text = "Дата скачивания: \(date)"
        downloadLabel.isHidden = false
        
        let ac = UIAlertController(title: "Сохранено", message: "Изображение сохранено в ваши фотографии", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
        ac.addAction(okAction)
        
        present(ac, animated: true, completion: nil)
    }
}
