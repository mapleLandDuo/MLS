//
//  DictDescriptionCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/02.
//

import UIKit

import SnapKit

class DictDescriptionCell: UITableViewCell {
    // MARK: Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .regular)
        label.textColor = .semanticColor.text.primary
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_md, fontType: .semiBold)
        label.textColor = .semanticColor.text.primary
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
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
private extension DictDescriptionCell {
    func setUp() {
        setUpConstraints()
        
        self.backgroundColor = .semanticColor.bg.primary
    }

    func setUpConstraints() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(Constants.spacings.sm)
            $0.top.trailing.bottom.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}

// MARK: bind
extension DictDescriptionCell {
    func bind(item: DetailContent) {
        titleLabel.text = item.title
        if item.title == "상점 판매가" {
            descriptionLabel.text = "\(item.description)메소"
        } else {
            descriptionLabel.text = item.description
        }
        
    }
}
