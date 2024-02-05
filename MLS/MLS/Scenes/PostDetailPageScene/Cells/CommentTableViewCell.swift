//
//  CommentTableViewCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/16.
//

import UIKit

import Kingfisher
import SnapKit

class CommentTableViewCell: UITableViewCell {
    // MARK: Components

    private let commentProfileNameLabel = CustomLabel(text: "userName", font: .boldSystemFont(ofSize: 16))

    lazy var optionStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [deletebutton, modifybutton])
        view.axis = .horizontal
        return view
    }()

    private let deletebutton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 12)
        button.setTitleColor(.red, for: .normal)
        return button
    }()

    private let modifybutton: UIButton = {
        let button = UIButton()
        button.setTitle("수정", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 12)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    private let commentTextLabel = CustomLabel(text: "comment", font: .systemFont(ofSize: 16))

    // MARK: Life Cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: SetUp
private extension CommentTableViewCell {
    
    func setUp() {
        setUpConstraints()
    }

    func setUpConstraints() {
        addSubview(commentProfileNameLabel)
        addSubview(optionStackView)
        addSubview(commentTextLabel)

        commentProfileNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.trailing.equalTo(optionStackView).inset(-Constants.defaults.horizontal)
        }

        optionStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }

        commentTextLabel.snp.makeConstraints {
            $0.top.equalTo(commentProfileNameLabel.snp.bottom).inset(-Constants.defaults.vertical / 2)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.bottom.equalToSuperview().inset(Constants.defaults.vertical / 2)
            $0.height.equalTo(30)
        }
    }
}

// MARK: Bind
extension CommentTableViewCell {

    func bind(name: String, comment: String) {
        commentProfileNameLabel.text = name
        commentTextLabel.text = comment
    }
}
