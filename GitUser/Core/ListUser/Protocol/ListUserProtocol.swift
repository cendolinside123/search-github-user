//
//  ListUserProtocol.swift
//  GitUser
//
//  Created by Jan Sebastian on 20/09/22.
//

import Foundation
import UIKit


protocol ListUserPresenterProtocol: AnyObject {
    associatedtype UserType
    var listUsers: [UserType] { get set }
    func fetchNextPage()
    func usersDidLoad(offset: Int, keyword text: String)
    func setupInteractor(_ interactor: ListUserInputInteractorProtocol)
    func setupView(_ view: ListUserViewProtocol)
    func setupRouter(_ router: ListUserRouterProtocol)
}

protocol ListUserViewProtocol: AnyObject {
    func showUsers<T>(_ items: T)
    func loadNextUsers<T>(_ items: T)
    func showError(error message: Error)
    func showLoading()
    func hideloading()
    func startReFetch()
    func endReFetch()
}

protocol ListUserInputInteractorProtocol: AnyObject {
    func userListUsers(offset: Int, page: Int, keyword text: String)
}

protocol ListUserOutputInteractorProtocol: AnyObject {
    func userListDidFetch<T>(_ items: T)
    func userListError<T>(error message: T)
}

protocol ListUserRouterProtocol: AnyObject {
    static func setupModule(view: UIViewController)
}
