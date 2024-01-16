//
//  CommentTableViewCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/16.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    // MARK: - Properties

    // MARK: - Components
    

    // MARK: - LifeCycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension CommentTableViewCell {
    // MARK: - SetUp

    func setUp() {

    }
}

extension CommentTableViewCell {
    // MARK: - Method

    func bind(imageUrl: URL) {
        
    }
}
