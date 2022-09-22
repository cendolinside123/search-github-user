//
//  GitUserTests.swift
//  GitUserTests
//
//  Created by Jan Sebastian on 22/09/22.
//

import XCTest
@testable import GitUser

class GitUserTests: XCTestCase {
    
    let presenter = MockupPresenter()
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
        presenter.usersDidLoad(offset: 1, keyword: "tom")
        XCTAssertGreaterThan(presenter.listUsers.count, 0)
    }
    
    func testStringEmpty() {
        presenter.usersDidLoad(offset: 1, keyword: "")
        XCTAssertEqual(presenter.listUsers.count, 0)
    }
    
    func testFildLoad() {
        presenter.userListError(error: ErrorResponse.CustomError(DataDummy.errorResponse.message))
        XCTAssertTrue(view.isError)
        XCTAssertNotNil(view.errorMessage)
        if let errorMessage = view.errorMessage {
            XCTAssertEqual(errorMessage.localizedDescription, DataDummy.errorResponse.message)
        }
        
    }
    
    func testReFetchData() {
        presenter.usersDidLoad(offset: 1, keyword: "tom")
        XCTAssertGreaterThan(presenter.listUsers.count, 0)
        view.startReFetch()
        presenter.fetchNextPage()
        view.endReFetch()
        XCTAssertGreaterThan(presenter.listUsers.count, 1)
    }

    func testReFetchData_thenReset() {
        presenter.usersDidLoad(offset: 1, keyword: "tom")
        XCTAssertGreaterThan(presenter.listUsers.count, 0)
        view.startReFetch()
        presenter.fetchNextPage()
        view.endReFetch()
        XCTAssertGreaterThan(presenter.listUsers.count, 1)
        presenter.usersDidLoad(offset: 1, keyword: "tom")
        XCTAssertGreaterThan(presenter.listUsers.count, 0)
    }
    
}

struct DataDummy {
    static let listUser = [
        Item(login: "tom", id: 748, nodeID: "MDQ6VXNlcjc0OA==", avatarURL: "https://avatars.githubusercontent.com/u/748?v=4", gravatarID: "", url: "https://api.github.com/users/tom", htmlURL: "https://github.com/tom", followersURL: "https://api.github.com/users/tom/followers", followingURL: "https://api.github.com/users/tom/following{/other_user}", gistsURL: "https://api.github.com/users/tom/gists{/gist_id}", starredURL: "https://api.github.com/users/tom/starred{/owner}{/repo}", subscriptionsURL: "https://api.github.com/users/tom/subscriptions", organizationsURL: "https://api.github.com/users/tom/orgs", reposURL: "https://api.github.com/users/tom/repos", eventsURL: "https://api.github.com/users/tom/events{/privacy}", receivedEventsURL: "https://api.github.com/users/tom/received_events", type: .user, siteAdmin: false, score: 1)
    ]
    
    /*{
     "login": "cen",
     "id": 459248,
     "node_id": "MDQ6VXNlcjQ1OTI0OA==",
     "avatar_url": "https://avatars.githubusercontent.com/u/459248?v=4",
     "gravatar_id": "",
     "url": "https://api.github.com/users/cen",
     "html_url": "https://github.com/cen",
     "followers_url": "https://api.github.com/users/cen/followers",
     "following_url": "https://api.github.com/users/cen/following{/other_user}",
     "gists_url": "https://api.github.com/users/cen/gists{/gist_id}",
     "starred_url": "https://api.github.com/users/cen/starred{/owner}{/repo}",
     "subscriptions_url": "https://api.github.com/users/cen/subscriptions",
     "organizations_url": "https://api.github.com/users/cen/orgs",
     "repos_url": "https://api.github.com/users/cen/repos",
     "events_url": "https://api.github.com/users/cen/events{/privacy}",
     "received_events_url": "https://api.github.com/users/cen/received_events",
     "type": "User",
     "site_admin": false,
     "score": 1.0
   }*/
    
    static let listUser2 = [
        Item(login: "cen", id: 459248, nodeID: "MDQ6VXNlcjQ1OTI0OA==", avatarURL: "https://avatars.githubusercontent.com/u/459248?v=4", gravatarID: "", url: "https://api.github.com/users/cen", htmlURL: "https://github.com/cen", followersURL: "https://api.github.com/users/cen/followers", followingURL: "https://api.github.com/users/cen/following{/other_user}", gistsURL: "https://api.github.com/users/cen/gists{/gist_id}", starredURL: "https://api.github.com/users/cen/starred{/owner}{/repo}", subscriptionsURL: "https://api.github.com/users/cen/subscriptions", organizationsURL: "https://api.github.com/users/cen/orgs", reposURL: "https://api.github.com/users/cen/repos", eventsURL: "https://api.github.com/users/cen/events{/privacy}", receivedEventsURL: "https://api.github.com/users/cen/received_events", type: .user, siteAdmin: false, score: 1)
    ]
    
    static let errorResponse = ErrorMessage(message: "error test", documentationURL: "")
}



class MockupView {
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
        isError = false
        errorMessage = nil
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
    
    func loadNextUsers<T>(_ items: T) {
        isError = false
        errorMessage = nil
    }
    
    func startReFetch() {
        didLoading = true
    }
    
    func endReFetch() {
        didLoading = false
    }
    
}


class MockupPresenter: ListUserPresenter {
    
    override init() {
        super.init()
    }
    
    override func fetchNextPage() {
        self.listUsers += DataDummy.listUser2
    }
    
}



class MockupIterator {
    fileprivate weak var presenter: ListUserOutputInteractorProtocol?
    
    init(presenter: ListUserOutputInteractorProtocol) {
        self.presenter = presenter
    }
}

extension MockupIterator: ListUserInputInteractorProtocol {
    func userListUsers(offset: Int, page: Int, keyword text: String) {
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
    func userListUsers(offset: Int, page: Int, keyword text: String) {
        presenter?.userListError(error: DataDummy.errorResponse.message)
    }
}
