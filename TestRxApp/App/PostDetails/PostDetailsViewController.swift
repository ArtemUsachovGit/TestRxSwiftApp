//
//  PostDetailsViewController.swift
//  TestRxApp
//
//  Created by Artem Usachov on 07.05.2021.
//

import UIKit
import RxSwift

class PostDetailsViewController: UIViewController {
    
    @IBOutlet weak var commentsTable: IntrinsicTableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private let bag = DisposeBag()
    private let cellIdentifier = R.reuseIdentifier.commentCell.identifier
    
    var viewModel: PostDetailsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        makeBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.loadComments()
    }
    
    func configureUI() {
        commentsTable.register(UINib(resource: R.nib.commentTableViewCell),
                               forCellReuseIdentifier: cellIdentifier)
        titleLabel.text = viewModel.post.title
        bodyLabel.text = viewModel.post.body
    }
    
    func makeBindings() {
        commentsTable
            .rx
            .setDelegate(self)
            .disposed(by: bag)
        
        viewModel
            .isLoading
            .asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: bag)
        
        viewModel
            .comments
            .bind(to: commentsTable.rx.items(cellIdentifier: cellIdentifier,
                                             cellType: CommentTableViewCell.self)) { _, comment, cell in
                cell.configure(with: comment)
            }
            .disposed(by: bag)
    }

}

extension PostDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
