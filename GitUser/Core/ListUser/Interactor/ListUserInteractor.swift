//
//  ListUserInteractor.swift
//  GitUser
//
//  Created by Jan Sebastian on 20/09/22.
//

import Foundation
import Alamofire

fileprivate protocol ListUserInteractorProtocolSetup {
    var presenter: ListUserOutputInteractorProtocol? { get set }
}


class ListUserInteractor {
    fileprivate weak var presenter: ListUserOutputInteractorProtocol?
    
    init(presenter: ListUserOutputInteractorProtocol) {
        self.presenter = presenter
    }
    
}

extension ListUserInteractor: ListUserInteractorProtocolSetup {
    
}

extension ListUserInteractor: ListUserInputInteractorProtocol {
     
    func userListUsers(offset: Int, page: Int, keyword text: String) {
        UserDataSource.getUser(searchKey: text, offset: offset, page: page, completion: { [weak self] response in
            switch response {
            case .success(let data):
                self?.presenter?.userListDidFetch(data.items)
            case .failure(let error):
                self?.presenter?.userListError(error: error)
            }
        })
    }
    
}


struct UserDataSource {
    
    static func getUser(searchKey text: String, offset: Int, page: Int, completion: @escaping (Result<Users, Error>) -> Void) {
        
        let url = Constant.Url.searchUser.routeAPI
        
        DispatchQueue.global().async {
            AF.request(url, method: .get, parameters: ["q": text, "per_page": offset, "page": page], encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseData(completionHandler: { response in
                switch response.result {
                case .success(let data):
                    DispatchQueue.main.async {
                        if let getUsers = try? JSONDecoder().decode(Users.self, from: data) {
                            completion(.success(getUsers))
                            return
                        } else {
                            guard let getErrorMessage = try? JSONDecoder().decode(ErrorMessage.self, from: data) else {
                                completion(.failure(ErrorResponse.UnknowError))
                                return
                            }
                            completion(.failure(ErrorResponse.CustomError(getErrorMessage.message)))
                            return
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(ErrorResponse.CustomError(error.localizedDescription)))
                        return
                    }
                }
            })
        }
    }
    
}
