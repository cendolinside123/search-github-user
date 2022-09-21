//
//  GitUserTableViewCell.swift
//  GitUser
//
//  Created by Jan Sebastian on 20/09/22.
//

import UIKit
import Kingfisher

class GitUserTableViewCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let stackViewContent: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private let userImage: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = .gray
        return imageview
    }()
    
    private let lblUserName: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = .white
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    private func setup() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        setupLayout()
        addConstraints()
    }
    
    private func setupLayout() {
        self.contentView.addSubview(containerView)
        containerView.addSubview(stackViewContent)
        stackViewContent.addArrangedSubview(userImage)
        stackViewContent.addArrangedSubview(lblUserName)
    }

    private func addConstraints() {
        let views: [String: Any] = ["containerView": containerView, "stackViewContent": stackViewContent]
        
        var constraints: [NSLayoutConstraint] = []
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let vContainerView = "V:|-2-[containerView]-2-|"
        let hContainerView = "H:|-2-[containerView]-2-|"
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vContainerView, options: .alignAllLeading, metrics: [:], views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hContainerView, options: .alignAllTop, metrics: [:], views: views)
        
        stackViewContent.translatesAutoresizingMaskIntoConstraints = false
        let vStackViewContent = "V:|-0-[stackViewContent]-0-|"
        let hStackViewContent = "H:|-0-[stackViewContent]-0-|"
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vStackViewContent, options: .alignAllLeading, metrics: [:], views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hStackViewContent, options: .alignAllTop, metrics: [:], views: views)
        
        userImage.translatesAutoresizingMaskIntoConstraints = false
        constraints += [NSLayoutConstraint(item: userImage, attribute: .width, relatedBy: .equal, toItem: containerView, attribute: .height, multiplier: 1, constant: 0)]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}

extension GitUserTableViewCell {
    func setupCell(_ item: Item) {
        lblUserName.text = item.login ?? "-"
        
        
    }
}
