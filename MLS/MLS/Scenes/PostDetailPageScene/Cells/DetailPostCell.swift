//
//  DetailPostCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/26.
//

import UIKit

import SnapKit



class DetailPostCell: UITableViewCell {

    // MARK: Components

    private let userNameButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = Typography.button.font
        return button
    }()
    
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
        let view = UIStackView(arrangedSubviews: [userNameButton, dateLabel, postCountLabel, spacerView])
        view.axis = .horizontal
        view.spacing = Constants.defaults.horizontal / 2
        return view
    }()
    
    private let postCountLabel = CustomLabel(text: "postCount", textColor: .gray, font: .systemFont(ofSize: 12))
    
    
    
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
        
        spacerView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        postTitleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}

extension DetailPostCell {
    // MARK: Method

    func bind(post: Post, vc: BasicController) {
        postTitleLabel.text = post.title
        IndicatorMaker.showLoading()
        post.user.toNickName { [weak self] nickName in
            IndicatorMaker.hideLoading()
            self?.userNameButton.setTitle(nickName, for: .normal)
            self?.userNameButton.addAction(UIAction(handler: { _ in
                let nextVC = ProfilePageViewController(viewModel: ProfilePageViewModel(email: post.user, nickName: nickName))
                vc.navigationController?.pushViewController(nextVC, animated: true)
            }), for: .primaryActionTriggered)
            
        }
        dateLabel.text = post.date.toString()
        postContentTextView.text = post.postContent
        postCountLabel.text = "조회수 \(String(post.viewCount))회"
    }
}
