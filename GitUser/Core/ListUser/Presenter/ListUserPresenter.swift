//
//  ListUserPresenter.swift
//  GitUser
//
//  Created by Jan Sebastian on 20/09/22.
//

import Foundation


fileprivate protocol ListUserPresenterProtocolSetup {
    var interactor: ListUserInputInteractorProtocol? { get set }
    var view: ListUserViewProtocol? { get set }
    var router: ListUserRouterProtocol? { get set }
}

class ListUserPresenter {
    fileprivate var interactor: ListUserInputInteractorProtocol?
    fileprivate weak var view: ListUserViewProtocol?
    fileprivate var router: ListUserRouterProtocol?
    
    private var waitProcess: Bool = false
    
    init() {
        
    }
    
}

extension ListUserPresenter: ListUserPresenterProtocolSetup {
    
}

extension ListUserPresenter: ListUserPresenterProtocol {
    func setupInteractor(_ interactor: ListUserInputInteractorProtocol) {
        self.interactor = interactor
    }
    
    func setupView(_ view: ListUserViewProtocol) {
        self.view = view
    }
    
    func setupRouter(_ router: ListUserRouterProtocol) {
        self.router = router
    }
    
    
    func usersDidLoad(keyword text: String) {
        
        if waitProcess {
            return
        }
        waitProcess = true
        view?.showLoading()
        
        if !text.isEmpty {
            interactor?.userListUsers(keyword: text)
        } else {
            view?.showUsers([])
            view?.hideloading()
        }
        
    }
    
    
}

extension ListUserPresenter {
    
}

extension ListUserPresenter: ListUserOutputInteractorProtocol {
    func userListDidFetch<T>(_ items: T) {
        view?.hideloading()
        guard let getListUser = items as? [Item] else {
            print("error response: wrong data type")
            return
        }
        view?.showUsers(getListUser)
        waitProcess = false
    }
    
    func userListError<T>(error message: T) {
        view?.hideloading()
        
        if let getMessage = message as? Error {
            print("error response: \(message)")
            view?.showError(error: getMessage)
        }
        waitProcess = false
    }
}
