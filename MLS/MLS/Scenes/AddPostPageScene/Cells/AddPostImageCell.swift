//
//  AddPostImageCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/15/24.
//

import UIKit

class AddPostImageCell: UICollectionViewCell {
    // MARK: - Components

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.defaults.radius
        return view
    }()

    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        button.tintColor = .systemGray4
        return button
    }()

    var callBackMethod: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AddPostImageCell {
    // MARK: - SetUp

    func setUp() {
        setUpConstraints()
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.layer.cornerRadius = Constants.defaults.radius
        deleteButton.addTarget(self, action: #selector(didTapButton), for: .primaryActionTriggered)
    }

    func setUpConstraints() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.height.width.equalTo(20)
        }
    }
}

private extension AddPostImageCell {
    // MARK: - Method

    @objc
    func didTapButton() {
        callBackMethod?()
    }
}

extension AddPostImageCell {
    // MARK: - Bind

    func bind(image: UIImage?) {
        imageView.image = image
    }
}
