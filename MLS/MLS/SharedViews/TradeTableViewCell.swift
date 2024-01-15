//
//  TradeTableViewCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/15.
//

import UIKit

class TradeTableViewCell: UITableViewCell {
    // MARK: Components

    private let dateLabel = CustomLabel(text: "date", textColor: .gray, fontSize: 12)
    
    private let tagLabel = CustomLabel(text: "tag", fontSize: 20)
    
    private let titleLabel = CustomLabel(text: "title", fontSize: 20)
    
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
        addSubview(tagLabel)
        addSubview(upCountLabel)
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Constants.defaults.vertical)
            $0.leading.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        
        tagLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).inset(-Constants.defaults.vertical)
            $0.leading.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.bottom.equalToSuperview().inset(Constants.defaults.vertical)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).inset(-Constants.defaults.vertical)
            $0.leading.equalTo(tagLabel.snp.trailing).inset(Constants.defaults.horizontal)
            $0.bottom.equalToSuperview().inset(Constants.defaults.vertical)
            $0.trailing.equalTo(upCountLabel.snp.leading).inset(Constants.defaults.horizontal)
        }
        
        upCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.bottom.equalToSuperview().inset(Constants.defaults.vertical)
            $0.centerY.equalTo(titleLabel)
        }
    }
    
    func bind(tag: Constants.PostType, title: String, date: String, upCount: String) {
        if tag == .normal {
            tagLabel.isHidden = true
        }
        tagLabel.text = tag.rawValue
        titleLabel.text = title
        dateLabel.text = date
        upCountLabel.text = upCount
    }
}
