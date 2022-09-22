//
//  GitUserTests.swift
//  GitUserTests
//
//  Created by Jan Sebastian on 22/09/22.
//

import XCTest
@testable import GitUser

class GitUserTests: XCTestCase {
    
    let presenter = ListUserPresenter()
    let view = MockupView()
    var interactor: ListUserInputInteractorProtocol?
    
    override func setUp() {
        interactor = MockupIterator(presenter: presenter)
        if let getInteractor = interactor {
            presenter.setupInteractor(getInteractor)
        }
        presenter.setupView(view)
    }
    
    func testLoadListUser() {
        presenter.usersDidLoad(keyword: "tom")
        XCTAssertGreaterThan(view.listItems.count, 0)
    }
    
    func testStringEmpty() {
        presenter.usersDidLoad(keyword: "")
        XCTAssertEqual(view.listItems.count, 0)
    }
    
    func testFildLoad() {
        presenter.userListError(error: ErrorResponse.CustomError(DataDummy.errorResponse.message))
        XCTAssertTrue(view.isError)
        XCTAssertNotNil(view.errorMessage)
        if let errorMessage = view.errorMessage {
//            XCTAssertTrue(errorMessage.localizedDescription == DataDummy.errorResponse.message)
            XCTAssertEqual(errorMessage.localizedDescription, DataDummy.errorResponse.message)
        }
        
    }

}

struct DataDummy {
    static let listUser = [
        Item(login: "tom", id: 748, nodeID: "MDQ6VXNlcjc0OA==", avatarURL: "https://avatars.githubusercontent.com/u/748?v=4", gravatarID: "", url: "https://api.github.com/users/tom", htmlURL: "https://github.com/tom", followersURL: "https://api.github.com/users/tom/followers", followingURL: "https://api.github.com/users/tom/following{/other_user}", gistsURL: "https://api.github.com/users/tom/gists{/gist_id}", starredURL: "https://api.github.com/users/tom/starred{/owner}{/repo}", subscriptionsURL: "https://api.github.com/users/tom/subscriptions", organizationsURL: "https://api.github.com/users/tom/orgs", reposURL: "https://api.github.com/users/tom/repos", eventsURL: "https://api.github.com/users/tom/events{/privacy}", receivedEventsURL: "https://api.github.com/users/tom/received_events", type: .user, siteAdmin: false, score: 1)
    ]
    static let errorResponse = ErrorMessage(message: "error test", documentationURL: "")
}



class MockupView {
    var listItems: [Item] = []
    var isError: Bool = false
    var didLoading: Bool = false {
        didSet {
            print("isLoading: \(didLoading)")
        }
    }
    var errorMessage: Error?
}

extension MockupView : ListUserViewProtocol {
    
    func showUsers<T>(_ items: T) {
        guard let getUser = items as? [Item] else {
            return
        }
        isError = false
        errorMessage = nil
        listItems = getUser
    }
    
    func showError(error message: Error) {
        isError = true
        errorMessage = message
    }
    
    func showLoading() {
        didLoading = true
    }
    
    func hideloading() {
        didLoading = false
    }
}



class MockupIterator {
    fileprivate weak var presenter: ListUserOutputInteractorProtocol?
    
    init(presenter: ListUserOutputInteractorProtocol) {
        self.presenter = presenter
    }
}

extension MockupIterator: ListUserInputInteractorProtocol {
    func userListUsers(keyword text: String) {
        let listUser = DataDummy.listUser
        self.presenter?.userListDidFetch(listUser)
    }
}



class MockupFailureIterator {
    fileprivate weak var presenter: ListUserOutputInteractorProtocol?
    
    init(presenter: ListUserOutputInteractorProtocol) {
        self.presenter = presenter
    }
}

extension MockupFailureIterator: ListUserInputInteractorProtocol {
    func userListUsers(keyword text: String) {
        presenter?.userListError(error: DataDummy.errorResponse.message)
    }
    
    
}
