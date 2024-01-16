//
//  PostDetailView.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/16.
//

import UIKit

import SnapKit

class PostDetailView: UIView {
    // MARK: - Components
    
    private let userIamgeView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.image = UIImage(systemName: "photo")?.resized(to: CGSize(width: 80, height: 80))
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        view.layer.cornerRadius = view.frame.height / 2
        return view
    }()
    
    private let userNameLabel = CustomLabel(text: "userName", font: .boldSystemFont(ofSize: 16))
    
    private let dateLabel = CustomLabel(text: "date", textColor: .gray, font: .systemFont(ofSize: 12))
    
    private let postTitleLabel = CustomLabel(text: "title", font: .boldSystemFont(ofSize: 20))
    
    private let postContentLabel: CustomLabel = {
        let label = CustomLabel(text: "content", font: .systemFont(ofSize: 20))
        label.numberOfLines = 0
        return label
    }()
    
    lazy var countStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [postCountLabel, upCountIcon, upCountLabel])
        view.axis = .horizontal
        return view
    }()
    
    private let postCountLabel = CustomLabel(text: "postCount", textColor: .gray, font: .systemFont(ofSize: 12))
    
    private let upCountIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "orangeMushroom")?.resized(to: CGSize(width: 30, height: 30))
        return view
    }()
    
    private let upCountLabel = CustomLabel(text: "upCount", textColor: .gray, font: .systemFont(ofSize: 12))

    // MARK: - LifeCycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

private extension PostDetailView {
    // MARK: - SetUp

    func setUp() {
        setUpConstraints()
        postContentLabel.text = "contentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontent"
        self.layer.borderColor = UIColor.systemOrange.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = Constants.defaults.radius
    }
    
    func setUpConstraints() {
        addSubview(userIamgeView)
        addSubview(userNameLabel)
        addSubview(dateLabel)
        addSubview(postTitleLabel)
        addSubview(postContentLabel)
        addSubview(countStackView)
        
        userIamgeView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Constants.defaults.vertical)
            $0.leading.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.leading.equalTo(userIamgeView.snp.trailing).inset(-Constants.defaults.horizontal)
            $0.bottom.equalTo(userIamgeView.snp.bottom)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(userIamgeView.snp.trailing).inset(-Constants.defaults.horizontal)
            $0.bottom.equalTo(userNameLabel.snp.top).inset(-Constants.defaults.vertical)
        }
        
        postTitleLabel.snp.makeConstraints {
            $0.top.equalTo(userIamgeView.snp.bottom).inset(-Constants.defaults.vertical * 2)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        
        postContentLabel.snp.makeConstraints {
            $0.top.equalTo(postTitleLabel.snp.bottom).inset(-Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        
        countStackView.snp.makeConstraints {
            $0.top.equalTo(postContentLabel.snp.bottom).inset(-Constants.defaults.vertical)
            $0.leading.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.bottom.equalToSuperview()
        }
    }
}
