//
//  ListUserViewController.swift
//  GitUser
//
//  Created by Jan Sebastian on 20/09/22.
//

import UIKit

class ListUserViewController: UIViewController {
    
    private var presenter: ListUserPresenterProtocol?
    
    private let searchNavBar: SearchBarView = SearchBarView()
    
    private let loadingView: LoadingView = LoadingView()
    
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
        setupConstraints()
        setupTabel()
        loadingView.isHidden = true
        
        
        ListUserRouter.setupModule(view: self)
        searchNavBar.didFinishType = { [weak self] text in
            self?.presenter?.usersDidLoad(keyword: text)
        }
    }
    
    private var listUser: [Item] = []
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
        
        let tabDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tabDismissKeyboard)
    }
    
    private func setupConstraints() {
        let views: [String: Any] = ["emptyBar": emptyBar, "tabelListUser": tabelListUser, "searchNavBar": searchNavBar]
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

extension ListUserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellUser", for: indexPath) as? GitUserTableViewCell else {
            return UITableViewCell()
        }
        cell.setupCell(listUser[indexPath.row])
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
    func getPresenter() -> ListUserPresenterProtocol? {
        return presenter
    }
    
    func setPresenter(_ presenter: ListUserPresenterProtocol) {
        self.presenter = presenter
    }
}

extension ListUserViewController: ListUserViewProtocol {
    func showError() {
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
        self.listUser = getListUser
        tabelListUser.reloadData()
    }
    
    func hideloading() {
        print("hide loading")
        loadingView.stopAnimate()
        loadingView.isHidden = true
    }
}

