//
//  PostTableViewCell.swift
//  TestRxApp
//
//  Created by Artem Usachov on 05.05.2021.
//

import UIKit

final class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var bodyLabel: UILabel!
    
    func configure(with post: Post) {
        titleLabel.text = post.title
        bodyLabel.text = post.body
    }
}
