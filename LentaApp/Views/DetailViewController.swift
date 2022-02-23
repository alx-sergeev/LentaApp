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
        
        downloadLabel.isHidden = true
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY hh:mm:ss"
        let dateString = dateFormatter.string(from: Date.init())
        
        downloadLabel.text = "Дата скачивания: \(dateString)"
        downloadLabel.isHidden = false
        
        let ac = UIAlertController(title: "Сохранено", message: "Изображение сохранено в ваши фотографии", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
        ac.addAction(okAction)
        
        present(ac, animated: true, completion: nil)
    }
}
