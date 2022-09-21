//
//  SearchBarView.swift
//  GitUser
//
//  Created by Jan Sebastian on 21/09/22.
//

import UIKit


protocol SearchBarViewProtocol: AnyObject {
    func doEditFinish(input text: String)
}

class SearchBarView: UIView {
    
    private let searchImage: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "searchIcon")
        imageview.backgroundColor = .white
        return imageview
    }()
    
    private let viewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let txtSearch: UITextField = {
        let inputText = UITextField()
        inputText.placeholder = "Search Github Users"
        inputText.backgroundColor = .white
        inputText.clearButtonMode = .whileEditing
        inputText.textColor = .black
        return inputText
    }()
    
    private var presenter: SearchBarPresenterProtocol?
    
    private var scheduleTypeCheck: Timer?
    
    var didFinishType: ((String) -> Void)?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setupConstraints()
        presenter = SearchBarViewPresenter(view: self)
        txtSearch.delegate = self
    }
    
    private func setupView() {
        backgroundColor = UIColor(red: (5/255), green: (195/255), blue: (221/255), alpha: 1)
        self.addSubview(viewContainer)
        viewContainer.addSubview(searchImage)
        viewContainer.addSubview(txtSearch)
    }

    private func setupConstraints() {
        let views: [String: Any] = ["viewContainer": viewContainer, "searchImage": searchImage, "txtSearch": txtSearch]
        
        var constraints: [NSLayoutConstraint] = []
        
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        constraints += [NSLayoutConstraint(item: viewContainer, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 2/3, constant: 0)]
        constraints += [NSLayoutConstraint(item: viewContainer, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 2.5/3, constant: 0)]
        constraints += [NSLayoutConstraint(item: viewContainer, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)]
        constraints += [NSLayoutConstraint(item: viewContainer, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)]
        
        searchImage.translatesAutoresizingMaskIntoConstraints = false
        txtSearch.translatesAutoresizingMaskIntoConstraints = false
        let hContent: String = "H:|-0-[searchImage]-0-[txtSearch]-0-|"
        let vSearchImage: String = "V:|-0-[searchImage]-0-|"
        let vTxtSearch: String = "V:|-0-[txtSearch]-0-|"
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hContent, options: .alignAllTop, metrics: [:], views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vSearchImage, options: .alignAllLeading, metrics: [:], views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vTxtSearch, options: .alignAllLeading, metrics: [:], views: views)
        constraints += [NSLayoutConstraint(item: searchImage, attribute: .width, relatedBy: .equal, toItem: txtSearch, attribute: .width, multiplier: 2/9, constant: 0)]
        
        NSLayoutConstraint.activate(constraints)
    }
}

extension SearchBarView: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        presenter?.doDebounce(input: txtSearch.text ?? "")
    }
}

extension SearchBarView: SearchBarViewProtocol {
    func doEditFinish(input text: String) {
        didFinishType?(text)
    }
}
