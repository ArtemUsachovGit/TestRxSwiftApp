//
//  IntrinsicTableView.swift
//  TestRxApp
//
//  Created by Artem Usachov on 07.05.2021.
//

import UIKit

class IntrinsicTableView: UITableView {
    
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
    
}
