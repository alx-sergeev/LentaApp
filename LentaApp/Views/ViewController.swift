//
//  ViewController.swift
//  LentaApp
//
//  Created by Сергеев Александр on 22.02.2022.
//

import UIKit

// MARK: - Protocol ViewControllerProtocol
protocol ViewControllerProtocol {
    func addPhotosForPage(photos: [Photo])
}

class ViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var myTableView: UITableView!
    
    // MARK: - Properties
    private var presenter: ViewControllerPresenterProtocol!
    
    private let cellName = "photoCell"
    private let segueToDetail = "toDetail"
    private var photos: [Photo] = []
    private var numPage = 1
    private let perPage = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = ViewControllerPresenter(view: self)
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        presenter?.fetchPhotosForPage(page: numPage, perPage: perPage)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == segueToDetail else { return }
        guard let detailVC = segue.destination as? DetailViewController else { return }
        guard let selectIndexPath = myTableView.indexPathForSelectedRow else { return }
        
        let imageData = photos[selectIndexPath.row]
        detailVC.imageData = imageData
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
            
            presenter?.fetchPhotosForPage(page: numPage, perPage: perPage)
        }
        
        let photo = photos[row]
        cell.configureCell(photo: photo)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueToDetail, sender: nil)
    }
}

// MARK: - ViewControllerProtocol
extension ViewController: ViewControllerProtocol {
    func addPhotosForPage(photos: [Photo]) {
        self.photos += photos
        
        DispatchQueue.main.async {
            self.myTableView.reloadData()
        }
    }
}
