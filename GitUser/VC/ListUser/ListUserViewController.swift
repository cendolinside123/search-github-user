//
//  ListUserViewController.swift
//  GitUser
//
//  Created by Jan Sebastian on 20/09/22.
//

import UIKit

class ListUserViewController: UIViewController {
    
    private var presenter: ListUserPresenter?
    
    private let searchNavBar: SearchBarView = SearchBarView()
    
    private let loadingView: LoadingView = LoadingView()
    
    private let bottomLoadingView: BottomLoadingView = BottomLoadingView()
    
    private let emptyBar: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    private let tabelListUser: UITableView = {
        let tabel = UITableView()
        tabel.backgroundColor = .white
        return tabel
    }()
    
    private var offset: Int = 12

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
        setupConstraints()
        setupTabel()
        loadingView.isHidden = true
        bottomLoadingView.stopAnimate()
        
        
        ListUserRouter.setupModule(view: self)
        searchNavBar.didFinishType = { [weak self] text in
            guard let strongSelf = self else {
                return
            }
            strongSelf.presenter?.usersDidLoad(offset: strongSelf.offset, keyword: text)
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func setupViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(emptyBar)
        emptyBar.addSubview(searchNavBar)
        self.view.addSubview(tabelListUser)
        self.view.addSubview(loadingView)
        self.view.addSubview(bottomLoadingView)
        
        if !UIDevice.current.iPad {
            if UIDevice.current.specialType {
                offset = 15
            } else {
                switch UIDevice.current.screenType {
                case .iPhones_4_4S, .iPhones_5_5s_5c_SE:
                    offset = 10
                default:
                    offset = 12
                }
            }
        } else {
            offset = 100
        }
        
        let tabDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tabDismissKeyboard)
    }
    
    private func setupConstraints() {
        let views: [String: Any] = ["emptyBar": emptyBar, "tabelListUser": tabelListUser, "searchNavBar": searchNavBar, "bottomLoadingView": bottomLoadingView]
        var constraints: [NSLayoutConstraint] = []
        
        emptyBar.translatesAutoresizingMaskIntoConstraints = false
        tabelListUser.translatesAutoresizingMaskIntoConstraints = false
        
        let hEmptyBar = "H:|-0-[emptyBar]-0-|"
        let hTabelListUser = "H:|-5-[tabelListUser]-5-|"
        let vContent = "V:|-[emptyBar]-0-[tabelListUser]-0-|"
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hEmptyBar, options: .alignAllTop, metrics: [:], views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hTabelListUser, options: .alignAllTop, metrics: [:], views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vContent, options: .alignAllCenterX, metrics: [:], views: views)
        constraints += [NSLayoutConstraint(item: emptyBar, attribute: .height, relatedBy: .equal, toItem: tabelListUser, attribute: .height, multiplier: 1/9, constant: 0)]
        
        
        searchNavBar.translatesAutoresizingMaskIntoConstraints = false
        let hSearchNavBar = "H:|-0-[searchNavBar]-0-|"
        let vSearchNavBar = "V:|-0-[searchNavBar]-0-|"
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hSearchNavBar, options: .alignAllTop, metrics: [:], views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vSearchNavBar, options: .alignAllCenterX, metrics: [:], views: views)
        
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        constraints += [NSLayoutConstraint(item: loadingView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1/5, constant: 0)]
        constraints += [NSLayoutConstraint(item: loadingView, attribute: .height, relatedBy: .equal, toItem: loadingView, attribute: .width, multiplier: 1, constant: 0)]
        constraints += [NSLayoutConstraint(item: loadingView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)]
        constraints += [NSLayoutConstraint(item: loadingView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)]
        
        
        bottomLoadingView.translatesAutoresizingMaskIntoConstraints = false
        let hBottomLoadingView = "H:|-0-[bottomLoadingView]-0-|"
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hBottomLoadingView, options: .alignAllBottom, metrics: [:], views: views)
        constraints += [NSLayoutConstraint(item: bottomLoadingView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 45)]
        let bottomLodingConstraint = NSLayoutConstraint(item: bottomLoadingView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 45)
        bottomLodingConstraint.identifier = "bottomLodingConstraint"
        constraints += [bottomLodingConstraint]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupTabel() {
        tabelListUser.delegate = self
        tabelListUser.dataSource = self
        tabelListUser.register(GitUserTableViewCell.self, forCellReuseIdentifier: "CellUser")
        tabelListUser.rowHeight = 50
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

}

extension ListUserViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYOffset

        if (distanceFromBottom < height) && (presenter?.listUsers.count != 0) {
            print("You reached end of the table")
            presenter?.fetchNextPage()
        }
    }
    
    private func toggleBottomLoading(isShow: Bool) {
        var allConstrains: [NSLayoutConstraint] = view.constraints
        guard let getIndex = ConstraintHelper.findConstraints(allConstrains, name: "bottomLodingConstraint") else {
            return
        }
        NSLayoutConstraint.deactivate(allConstrains)
        
        if isShow {
            allConstrains[getIndex] = NSLayoutConstraint(item: bottomLoadingView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        } else {
            allConstrains[getIndex] = NSLayoutConstraint(item: bottomLoadingView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 45)
        }
        allConstrains[getIndex].identifier = "bottomLodingConstraint"
        
        NSLayoutConstraint.activate(allConstrains)
        view.layoutIfNeeded()
    }
    
}

extension ListUserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.listUsers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellUser", for: indexPath) as? GitUserTableViewCell, let getUser = presenter?.listUsers[indexPath.row] else {
            return UITableViewCell()
        }
        cell.setupCell(getUser)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellUser", for: indexPath) as? GitUserTableViewCell else {
            return
        }
        cell.cancelLoadImage()
    }
}

extension ListUserViewController {
    func getPresenter() -> ListUserPresenter? {
        return presenter
    }
    
    func setPresenter(_ presenter: ListUserPresenter) {
        self.presenter = presenter
    }
}

extension ListUserViewController: ListUserViewProtocol {
    func loadNextUsers<T>(_ items: T) {
        guard let getListItem = items as? [IndexPath] else {
            return
        }
        tabelListUser.beginUpdates()
        tabelListUser.insertRows(at: getListItem, with: .bottom)
    }
    
    func startReFetch() {
        print("begin re-fetch")
        self.toggleBottomLoading(isShow: true)
        self.bottomLoadingView.startAnimate()
    }
    
    func endReFetch() {
        print("end re-fetch")
        tabelListUser.endUpdates()
        self.toggleBottomLoading(isShow: false)
        self.bottomLoadingView.stopAnimate()
    }
    
    func showError(error message: Error) {
        print("show error")
    }
    
    func showLoading() {
        print("show loading")
        loadingView.isHidden = false
        loadingView.startAnimate()
    }
    
    func showUsers<T>(_ items: T) {
        guard let getListUser = items as? [Item] else {
            return
        }
        tabelListUser.reloadData()
        if getListUser.count != 0 {
            tabelListUser.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
    func hideloading() {
        print("hide loading")
        loadingView.stopAnimate()
        loadingView.isHidden = true
    }
}

