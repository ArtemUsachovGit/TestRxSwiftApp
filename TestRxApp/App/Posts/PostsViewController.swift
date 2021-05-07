//
//  PostsViewController.swift
//  TestRxApp
//
//  Created by Artem Usachov on 05.05.2021.
//

import UIKit
import RxSwift

final class PostsViewController: UIViewController, Coordinatable {
    
    weak var coordinator: PostsCoordinator?
    
    @IBOutlet weak private var modeControl: UISegmentedControl!
    @IBOutlet weak private var postsTable: UITableView!
    @IBOutlet weak private var loadingIndicator: UIActivityIndicatorView!
    
    var viewModel: PostsViewModel!
    
    private let bag = DisposeBag()
    private let cellIdentifier = R.reuseIdentifier.postCell.identifier
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        makeBindings()
        viewModel.loadPosts()
    }

}

private extension PostsViewController {
    
    func configureUI() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Posts"
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        postsTable.tableHeaderView = searchController.searchBar
        
        postsTable.register(UINib(resource: R.nib.postTableViewCell),
                            forCellReuseIdentifier: cellIdentifier)
        postsTable.tableFooterView = UIView()
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logout))
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    @objc func logout() {
        viewModel.logout()
        coordinator?.doLogout()
    }
    
    func makeBindings() {
        modeControl
            .rx
            .value
            .compactMap { PostsViewModel.Mode(rawValue: $0) }
            .bind(to: viewModel.selectedMode)
            .disposed(by: bag)
        
        viewModel
            .posts
            .bind(to: postsTable.rx.items(cellIdentifier: cellIdentifier, cellType: PostTableViewCell.self)) { _, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: bag)
        
        postsTable
            .rx
            .setDelegate(self)
            .disposed(by: bag)

        viewModel
            .isLoading
            .asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: bag)

    }
}

extension PostsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.isActive,
              let searchQuery = searchController.searchBar.text else { return }
        viewModel.searchQuery.accept(searchQuery)
    }
}

extension PostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let post = viewModel.selected(postAt: indexPath.row)
        coordinator?.showDetails(for: post)
    }
}
