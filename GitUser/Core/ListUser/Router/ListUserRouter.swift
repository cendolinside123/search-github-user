//
//  ListUserRouter.swift
//  GitUser
//
//  Created by Jan Sebastian on 20/09/22.
//

import Foundation
import UIKit

class ListUserRouter {
    
}

extension ListUserRouter: ListUserRouterProtocol {
    static func setupModule(view: UIViewController) {
        guard let getView = view as? ListUserViewController else {
            return
        }
        let presenter = ListUserPresenter()
        
        getView.setPresenter(presenter)
        getView.getPresenter()?.setupInteractor(ListUserInteractor(presenter: presenter))
        getView.getPresenter()?.setupView(getView)
        getView.getPresenter()?.setupRouter(ListUserRouter())
    }
}
