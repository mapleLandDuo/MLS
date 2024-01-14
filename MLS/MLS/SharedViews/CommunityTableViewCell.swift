//
//  CommunityTableViewCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/14.
//

import UIKit

import SnapKit

class CommunityTableViewCell: UITableViewCell {
    // MARK: Components

    private let dateLabel = CustomLabel(text: "date", textColor: .gray, fontSize: 12)
    
    private let titleLabel = CustomLabel(text: "title", textColor: .black, fontSize: 20)
    
    private let upCountLabel = CustomLabel(text: "upCount", textColor: .gray, fontSize: 16)
    
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

    private func setUpConstraints() {
        addSubview(dateLabel)
        addSubview(titleLabel)
        addSubview(upCountLabel)
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Constants.defaults.vertical)
            $0.leading.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).inset(-Constants.defaults.vertical)
            $0.leading.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.bottom.equalToSuperview().inset(Constants.defaults.vertical)
            $0.trailing.equalTo(upCountLabel.snp.leading).inset(Constants.defaults.horizontal)
        }
        
        upCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.bottom.equalToSuperview().inset(Constants.defaults.vertical)
            $0.centerY.equalTo(titleLabel)
        }
    }
    
    func bind(date: String, title: String, upCount: String) {
        dateLabel.text = date
        titleLabel.text = title
        upCountLabel.text = upCount
    }
}
