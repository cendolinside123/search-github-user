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
    
    typealias UserType = Item
    
    fileprivate var interactor: ListUserInputInteractorProtocol?
    fileprivate weak var view: ListUserViewProtocol?
    fileprivate var router: ListUserRouterProtocol?
    
    private var waitProcess: Bool = false
    private var offsetPage: Int = 0
    private var currentPage: Int = 0
    private var tempKeyworld: String = ""
    
    private var delayTimer: Timer?
    
    var listUsers: [Item] = []
    
    init() {
        
    }
    
    func fetchNextPage() {
        if waitProcess {
            return
        }
        
        if delayTimer != nil {
            delayTimer?.invalidate()
            delayTimer = nil
        }
        view?.startReFetch()
        delayTimer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(doDelayedRequest), userInfo: nil, repeats: false)
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
    
    
    func usersDidLoad(offset: Int, keyword text: String) {
        
        if waitProcess {
            return
        }
        waitProcess = true
        self.offsetPage = offset
        self.currentPage = 1
        self.listUsers = []
        view?.showLoading()
        
        if !text.isEmpty {
            tempKeyworld = text
            interactor?.userListUsers(offset: offset, page: 0, keyword: text)
        } else {
            view?.showUsers([])
            view?.hideloading()
        }
        
    }
    
    @objc private func doDelayedRequest() {
        waitProcess = true
        self.currentPage = self.currentPage + 1
        let offset = self.offsetPage
        let page = self.currentPage
        let key = self.tempKeyworld
        
        interactor?.userListUsers(offset: offset, page: page, keyword: key)
    }
    
    
}

extension ListUserPresenter {
    
}

extension ListUserPresenter: ListUserOutputInteractorProtocol {
    func userListDidFetch<T>(_ items: T) {
        if self.currentPage == 1 {
            guard let getListUser = items as? [Item] else {
                print("error response: wrong data type")
                waitProcess = false
                view?.hideloading()
                return
            }
            listUsers = getListUser
            view?.hideloading()
            view?.showUsers(listUsers)
        } else {
            guard let getListUser = items as? [Item] else {
                print("error response: wrong data type: \(items)")
                self.currentPage = self.currentPage - 1
                waitProcess = false
                view?.endReFetch()
                return
            }
            
            let getDifference = Set(getListUser).subtracting(Set(listUsers))
            if getDifference.count != 0 {
                var listIndex: [IndexPath] = []
                let start = listUsers.count
                print("start: \(listUsers.count) ")
                let end = (listUsers.count + (getDifference.count - 1))
                print("end: \(listUsers.count) + \(getDifference.count - 1) = \(end)")
                for index in start...end {
                    listIndex.append(IndexPath(row: index, section: 0))
                }
                listUsers += getDifference
                view?.loadNextUsers(listIndex)
                view?.endReFetch()
            } else {
                view?.endReFetch()
            }
            
        }
        waitProcess = false
    }
    
    func userListError<T>(error message: T) {
        
        if let getMessage = message as? Error {
            print("error response: \(message)")
            view?.showError(error: getMessage)
        }
        
        if self.currentPage == 1 {
            view?.hideloading()
        } else {
            view?.endReFetch()
        }
        
        waitProcess = false
    }
}
