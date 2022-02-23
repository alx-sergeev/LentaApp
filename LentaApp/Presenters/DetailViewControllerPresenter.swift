//
//  DetailViewControllerPresenter.swift
//  LentaApp
//
//  Created by Сергеев Александр on 23.02.2022.
//

import Foundation

// MARK: - Protocol ViewControllerPresenterProtocol
protocol DetailViewControllerPresenterProtocol: AnyObject {
    init(view: DetailViewControllerProtocol)
    func fetchDetailPhoto(path: String)
    func didSavePhoto()
}

class DetailViewControllerPresenter: DetailViewControllerPresenterProtocol {
    // MARK: - Properties
    private var view: DetailViewControllerProtocol?
    private let networkManager: NetworkManagerProtocol = NetworkManager.shared

    required init(view: DetailViewControllerProtocol) {
        self.view = view
    }
    
    // MARK: - Methods
    func fetchDetailPhoto(path: String) {
        networkManager.fetchItem(path: path) { [weak self] (image) in
            guard let self = self else { return }
            
            self.view?.showDetailPhoto(image: image)
        }
    }
    
    func didSavePhoto() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY hh:mm:ss"
        let dateString = dateFormatter.string(from: Date.init())
        
        view?.showInfoDownloadPhoto(date: dateString)
    }
}
