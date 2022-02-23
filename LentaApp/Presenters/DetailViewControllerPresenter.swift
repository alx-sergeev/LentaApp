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

    required init(view: DetailViewControllerProtocol) {
        self.view = view
    }
    
    // MARK: - Methods
    func fetchDetailPhoto(path: String) {
        guard let URL = URL(string: path) else { return }
        guard let imageData = try? Data(contentsOf: URL) else { return }
        
        view?.showDetailPhoto(imageData: imageData)
    }
    
    func didSavePhoto() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY hh:mm:ss"
        let dateString = dateFormatter.string(from: Date.init())
        
        view?.showInfoDownloadPhoto(date: dateString)
    }
}
