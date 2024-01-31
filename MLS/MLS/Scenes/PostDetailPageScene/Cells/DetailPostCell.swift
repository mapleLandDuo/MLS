//
//  DetailPostCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/26.
//

import UIKit

import SnapKit

protocol DetailPostCellDelegate: AnyObject {
    func tapUpCountButton(cell: DetailPostCell)
}

class DetailPostCell: UITableViewCell {
    // MARK: Properties
    weak var delegate: DetailPostCellDelegate?
    
    // MARK: Components

    private let userNameLabel = CustomLabel(text: "", font: .boldSystemFont(ofSize: 16))
    
    private let dateLabel = CustomLabel(text: "", textColor: .gray, font: .systemFont(ofSize: 12))
    
    private let postTitleLabel = CustomLabel(text: "", font: .boldSystemFont(ofSize: 24))
    
    private let postContentTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 20)
        return textView
    }()
    
    private let spacerView = UIView()
    
    lazy var infoStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [userNameLabel, dateLabel, postCountLabel, upCountIcon, upCountLabel, spacerView])
        view.axis = .horizontal
        view.spacing = Constants.defaults.horizontal / 2
        return view
    }()
    
    private let postCountLabel = CustomLabel(text: "postCount", textColor: .gray, font: .systemFont(ofSize: 12))
    
    private let upCountIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "orangeMushroom")?.resized(to: CGSize(width: 30, height: 30))
        return view
    }()
    
    private let upCountLabel = CustomLabel(text: "upCount", textColor: .gray, font: .systemFont(ofSize: 12))

    lazy var upCountButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = false
        button.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = Constants.defaults.radius
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.layer.borderWidth = 1
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 2
        button.addAction(UIAction(handler: { [weak self] _ in
            if let self = self {
                self.delegate?.tapUpCountButton(cell: self)
            }
        }), for: .touchUpInside)
        return button
    }()
    
    // MARK: LifeCycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DetailPostCell {
    // MARK: SetUp

    func setUp() {
        setUpConstraints()
    }

    func setUpConstraints() {
        addSubview(postTitleLabel)
        addSubview(infoStackView)
        addSubview(postContentTextView)
        addSubview(upCountButton)
        
        postTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Constants.defaults.vertical)
            $0.top.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        
        infoStackView.snp.makeConstraints {
            $0.top.equalTo(postTitleLabel.snp.bottom).inset(-Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        
        postContentTextView.snp.makeConstraints {
            $0.top.equalTo(infoStackView.snp.bottom).inset(-Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        
        upCountButton.snp.makeConstraints {
            $0.top.equalTo(postContentTextView.snp.bottom).inset(-Constants.defaults.vertical)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(Constants.defaults.vertical)
            $0.size.equalTo(60)
        }
        
        spacerView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        postTitleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}

extension DetailPostCell {
    // MARK: Method

    func bind(post: Post, isUp: Bool) {
        postTitleLabel.text = post.title
        post.user.toNickName { [weak self] nickName in
            self?.userNameLabel.text = nickName
        }
        dateLabel.text = post.date.toString()
        postContentTextView.text = post.postContent
        postCountLabel.text = "\(String(post.viewCount))회"
        upCountLabel.text = String(post.likes.count)
        upCountButton.setImage(isUp ? UIImage(systemName: "hand.thumbsup.fill") : UIImage(systemName: "hand.thumbsup"), for: .normal)
    }
}
