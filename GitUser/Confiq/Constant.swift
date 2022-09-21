//
//  Constant.swift
//  GitUser
//
//  Created by Jan Sebastian on 20/09/22.
//

import Foundation


struct Constant {
    static let baseURL: String = "https://api.github.com"
    
    struct Url {
        static let searchUser: String = "/search/users"
    }
    
}

enum ErrorResponse: Error, LocalizedError {
    case UnknowError
    case CustomError(String)
    
    var errorDescription: String? {
        switch self {
        case .UnknowError:
            return NSLocalizedString(
                "Unknow Error",
                comment: ""
            )
        
        case .CustomError(let errorMessage):
            return NSLocalizedString(
                "\(errorMessage)",
                comment: ""
            )
        }
    }
}

extension String {
    
    var routeAPI: String {
        return Constant.baseURL + self
    }
    
}
