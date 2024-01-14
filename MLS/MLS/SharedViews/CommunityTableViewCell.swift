//
//  CommunityTableViewCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/14.
//

import UIKit

class CommunityTableViewCell: UITableViewCell {
    // MARK: Components
    
    
    // MARK: LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setUpConstraints()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func setUpConstraints() {
        
    }
}
