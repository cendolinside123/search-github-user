//
//  BottomLoadingView.swift
//  GitUser
//
//  Created by Jan Sebastian on 22/09/22.
//

import UIKit

class BottomLoadingView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    private let loadingAnimate: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            loadingView.style = UIActivityIndicatorView.Style.medium
        } else {
            // Fallback on earlier versions
            loadingView.style = UIActivityIndicatorView.Style.gray
        }
        loadingView.color = .black
        return loadingView
    }()
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setupConstraints()
    }
    
    private func setupView() {
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.addSubview(loadingAnimate)
    }
    
    private func setupConstraints() {
        var constraints: [NSLayoutConstraint] = []
        
        loadingAnimate.translatesAutoresizingMaskIntoConstraints = false
        constraints += [NSLayoutConstraint(item: loadingAnimate, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)]
        constraints += [NSLayoutConstraint(item: loadingAnimate, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)]
        constraints += [NSLayoutConstraint(item: loadingAnimate, attribute: .width, relatedBy: .equal, toItem: loadingAnimate, attribute: .height, multiplier: 1, constant: 0)]
        NSLayoutConstraint.activate(constraints)
        
    }
    
}

extension BottomLoadingView {
    func startAnimate() {
        loadingAnimate.startAnimating()
    }
    
    func stopAnimate() {
        loadingAnimate.stopAnimating()
    }
}
