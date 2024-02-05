//
//  PostDetailView.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/16.
//

import UIKit

import Kingfisher
import SnapKit

class PostDetailView: UIView {
    // MARK: - Components

    private let userNameLabel = CustomLabel(text: "userName", font: .boldSystemFont(ofSize: 16))

    private let dateLabel = CustomLabel(text: "date", textColor: .gray, font: .systemFont(ofSize: 12))

    private let postTitleLabel = CustomLabel(text: "title", font: .boldSystemFont(ofSize: 24))

    private let postContentLabel: CustomLabel = {
        let label = CustomLabel(text: "content", font: .systemFont(ofSize: 20))
        label.numberOfLines = 0
        return label
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

    // MARK: - LifeCycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - SetUp
private extension PostDetailView {


    func setUp() {
        setUpConstraints()
    }

    func setUpConstraints() {
        addSubview(postTitleLabel)
        addSubview(infoStackView)
        addSubview(postContentLabel)

        postTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Constants.defaults.vertical)
            $0.top.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }

        infoStackView.snp.makeConstraints {
            $0.top.equalTo(postTitleLabel.snp.bottom).inset(-Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }

        postContentLabel.snp.makeConstraints {
            $0.top.equalTo(infoStackView.snp.bottom).inset(-Constants.defaults.vertical)
            $0.leading.trailing.bottom.equalToSuperview().inset(Constants.defaults.horizontal)
        }

        spacerView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}

extension PostDetailView {
    func updateUI(userImage: URL, date: Date, userName: String, title: String, content: String, postCount: Int, upCount: Int) {
        dateLabel.text = date.toString()
        userNameLabel.text = userName
        postTitleLabel.text = title
        postContentLabel.text = content
        postCountLabel.text = "조회수: \(postCount) / "
        upCountLabel.text = String(upCount)
    }
}
