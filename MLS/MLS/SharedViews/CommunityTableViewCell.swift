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

    private let postView = UIView()
    
    private let dateLabel = CustomLabel(text: "date", textColor: .gray, font: .systemFont(ofSize: 12))
    
    lazy var postStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [tagLabel, titleLabel, upCountIcon, upCountLabel])
        view.spacing = Constants.defaults.horizontal / 2
        return view
    }()
    
    private let tagLabel: UILabel = {
        let label = CustomLabel(text: "tag", font: .boldSystemFont(ofSize: 20), padding: UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5))
        label.textAlignment = .center
        label.layer.borderWidth = 2
        label.layer.cornerRadius = Constants.defaults.radius
        return label
    }()
    
    private let titleLabel = CustomLabel(text: "title", font: .systemFont(ofSize: 20))
    
    private let upCountIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "orangeMushroom")?.resized(to: CGSize(width: 30, height: 30))
        return view
    }()
    
    private let upCountLabel = CustomLabel(text: "upCount", textColor: .gray, font: .systemFont(ofSize: 16))
    
    // MARK: LifeCycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Bind

    func bind(tag: BoardSeparatorType, title: String, date: String, upCount: String) {
        setUpType(tag: tag)
        tagLabel.text = tag.rawValue
        titleLabel.text = title
        dateLabel.text = date
        upCountLabel.text = upCount
    }
}

private extension CommunityTableViewCell {
    // MARK: Methods

    func setUp() {
//        setUpcell()
        setUpConstraints()
    }
    
    func setUpcell() {
        postView.layer.borderWidth = 1
        postView.layer.borderColor = UIColor.systemGray4.cgColor
        postView.layer.cornerRadius = Constants.defaults.radius
    }

    func setUpConstraints() {
        addSubview(postView)
        postView.addSubview(dateLabel)
        postView.addSubview(postStackView)
        
        postView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
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
    
    func setUpType(tag: BoardSeparatorType) {
        switch tag {
        case .normal:
            tagLabel.isHidden = true
        case .buy:
            tagLabel.textColor = .systemBlue
            tagLabel.layer.borderColor = UIColor.systemBlue.cgColor
        case .sell:
            tagLabel.textColor = .systemRed
            tagLabel.layer.borderColor = UIColor.systemRed.cgColor
        case .complete:
            let attributeString = NSAttributedString(string: tag.rawValue, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: UIColor.gray])
            tagLabel.attributedText = attributeString
            tagLabel.layer.borderColor = UIColor.gray.cgColor
        }
    }
}
