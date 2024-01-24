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

//    private let commentProfileImageView: UIImageView = {
//        let view = UIImageView()
//        view.image = UIImage(systemName: "photo")?.resized(to: CGSize(width: 30, height: 30))
//        view.clipsToBounds = true
//        view.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        view.layer.cornerRadius = view.frame.height / 2
//        return view
//    }()

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

extension CommentTableViewCell {
    // MARK: Bind

    func bind(name: String, comment: String) {
//        commentProfileImageView.kf.setImage(with: image)
        commentProfileNameLabel.text = name
        commentTextLabel.text = comment
    }
}

private extension CommentTableViewCell {
    // MARK: Methods

    func setUp() {
        setUpConstraints()
    }

    func setUpConstraints() {
//        addSubview(commentProfileImageView)
        addSubview(commentProfileNameLabel)
        addSubview(optionStackView)
        addSubview(commentTextLabel)

//        commentProfileImageView.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.leading.equalToSuperview().inset(Constants.defaults.horizontal)
//            $0.size.equalTo(30)
//        }

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
