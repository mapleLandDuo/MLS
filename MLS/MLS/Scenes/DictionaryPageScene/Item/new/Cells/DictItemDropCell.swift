//
//  DictItemDropCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/01.
//

import UIKit

import SnapKit

class DictItemDropCell: UITableViewCell {
    // MARK: Components

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: SetUp
private extension DictItemDropCell {

    func setUp() {
        setUpConstraints()
    }

    func setUpConstraints() {
       
    }
}

// MARK: bind
extension DictItemDropCell {

    func bind(item: DictionaryItem) {
        
    }
}
