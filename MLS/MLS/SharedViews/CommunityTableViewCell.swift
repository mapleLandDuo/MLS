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
    
    lazy var postStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [tagLabel, titleLabel, upCountLabel])
        view.spacing = Constants.defaults.horizontal
        return view
    }()
    
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
        addSubview(postStackView)
//        addSubview(titleLabel)
//        addSubview(tagLabel)
//        addSubview(upCountLabel)
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Constants.defaults.vertical)
            $0.leading.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        
        postStackView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).inset(-Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.bottom.equalToSuperview().inset(Constants.defaults.vertical)
        }
        
        tagLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    func bind(tag: Constants.PostType, title: String, date: String, upCount: String) {
        setUpNormal(tag: tag)
        tagLabel.text = tag.rawValue
        titleLabel.text = title
        dateLabel.text = date
        upCountLabel.text = upCount
    }
    
    private func setUpNormal(tag: Constants.PostType) {
        if tag == .normal {
            tagLabel.isHidden = true
        }
    }
}
