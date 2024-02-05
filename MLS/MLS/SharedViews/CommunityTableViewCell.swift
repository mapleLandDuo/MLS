//
//  CommunityTableViewCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/14.
//

import UIKit

import SnapKit

//Typography 적용
//leading trailing <- 사용
//make <- 사용
// addSubView 위로 정렬
// $0으로 make 어쩌구 저ㄱ쩌구..
// inset Offset 구분 사용

class CommunityTableViewCell: UITableViewCell {
    // MARK: Components
    
    private let postView = UIView()
    
    private let dateLabel = CustomLabel(text: "date", textColor: .gray, font: .systemFont(ofSize: 12))
    
    lazy var postStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [tagLabel, titleLabel])
        view.spacing = Constants.defaults.horizontal / 2
        return view
    }()
    
    private let tagLabel: UILabel = {
        let label = CustomLabel(text: "tag", font: .boldSystemFont(ofSize: 20), padding: UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5))
        label.textAlignment = .center
        label.layer.borderWidth = 2
        label.layer.cornerRadius = Constants.defaults.radius
        label.isHidden = false
        return label
    }()
    
    private let titleLabel = CustomLabel(text: "title", font: .systemFont(ofSize: 20))
    
    private let upCountIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "orangeMushroom")?.resized(to: CGSize(width: 30, height: 30))
        return view
    }()
    
    private let upCountLabel = CustomLabel(text: "upCount", textColor: .gray, font: .systemFont(ofSize: 16))
    
    // MARK: Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        titleLabel.attributedText = nil
    }
}

// MARK: Bind
extension CommunityTableViewCell {
    
    func bind(tag: BoardSeparatorType, title: String, date: String, upCount: String) {
        titleLabel.text = title
        dateLabel.text = date
        upCountLabel.text = upCount
        setUpType(tag: tag)
    }
}

// MARK: SetUp
private extension CommunityTableViewCell {
    
    func setUp() {
        setUpConstraints()
    }
    
    func setUpConstraints() {
        addSubview(postView)
        postView.addSubview(postStackView)
        postView.addSubview(dateLabel)
        postView.addSubview(upCountIcon)
        postView.addSubview(upCountLabel)
        
        postView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        postStackView.snp.makeConstraints {
            $0.top.equalTo(postView).inset(Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(postStackView.snp.bottom).inset(-Constants.defaults.vertical / 2)
            $0.leading.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.bottom.equalToSuperview().inset(Constants.defaults.horizontal / 2)
        }
        
        upCountIcon.snp.makeConstraints {
            $0.top.equalTo(postStackView.snp.bottom).inset(-Constants.defaults.vertical / 2)
            $0.trailing.equalTo(upCountLabel.snp.leading).inset(-Constants.defaults.horizontal)
            $0.bottom.equalToSuperview().inset(Constants.defaults.horizontal / 2)
        }
        
        upCountLabel.snp.makeConstraints {
            $0.top.equalTo(postStackView.snp.bottom).inset(-Constants.defaults.vertical / 2)
            $0.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.bottom.equalToSuperview().inset(Constants.defaults.horizontal / 2)
        }
        
        tagLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    func setUpType(tag: BoardSeparatorType) {
        var attributeString = NSAttributedString()
        tagLabel.isHidden = false
        
        switch tag {
        case .normal:
            tagLabel.isHidden = true
        case .buy:
            attributeString = NSAttributedString(string: tag.rawValue, attributes: [NSAttributedString.Key.strikethroughStyle: 0, NSAttributedString.Key.foregroundColor: UIColor.systemRed])
            tagLabel.layer.borderColor = UIColor.systemRed.cgColor
        case .sell:
            attributeString = NSAttributedString(string: tag.rawValue, attributes: [NSAttributedString.Key.strikethroughStyle: 0, NSAttributedString.Key.foregroundColor: UIColor.systemBlue])
            tagLabel.layer.borderColor = UIColor.systemBlue.cgColor
        case .complete:
            attributeString = NSAttributedString(string: tag.rawValue, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: UIColor.gray])
            tagLabel.layer.borderColor = UIColor.gray.cgColor
        }
        tagLabel.attributedText = attributeString
    }
}
