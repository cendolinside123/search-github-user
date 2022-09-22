//
//  SearchBarViewPresenter.swift
//  GitUser
//
//  Created by Jan Sebastian on 21/09/22.
//

import Foundation


protocol SearchBarPresenterProtocol {
    var userInput: String { get set }
    func doDebounce(input text: String)
}

class SearchBarViewPresenter {
    var userInput: String = ""
    private var checkInputSchedule: Timer?
    private weak var view: SearchBarViewProtocol?
    
    init(view: SearchBarViewProtocol) {
        self.view = view
    }
    
}


extension SearchBarViewPresenter: SearchBarPresenterProtocol {
    
    func doDebounce(input text: String) {
        if checkInputSchedule != nil {
            checkInputSchedule?.invalidate()
            checkInputSchedule = nil
        }
        
        userInput = text
        
        checkInputSchedule = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(doInput), userInfo: nil, repeats: false)
        
    }
    
    @objc private func doInput() {
        print("timer doDebounce end here")
        view?.doEditFinish(input: userInput)
    }
}
