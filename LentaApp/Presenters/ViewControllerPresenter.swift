//
//  ViewControllerPresenter.swift
//  LentaApp
//
//  Created by Сергеев Александр on 23.02.2022.
//

// MARK: - Protocol ViewControllerPresenterProtocol
protocol ViewControllerPresenterProtocol: AnyObject {
    init(view: ViewControllerProtocol)
    func fetchPhotosForPage(page: Int, perPage: Int)
}

class ViewControllerPresenter: ViewControllerPresenterProtocol {
    // MARK: - Properties
    private var view: ViewControllerProtocol?
    private let networkManager: NetworkManagerProtocol = NetworkManager.shared
    
    required init(view: ViewControllerProtocol) {
        self.view = view
    }
    
    // MARK: - Methods
    func fetchPhotosForPage(page: Int, perPage: Int) {
        let _ = networkManager.fetchData(page: page, perPage: perPage) { [weak self] decodeData in
            
            self?.view?.addPhotosForPage(photos: decodeData)
        }
    }
}
