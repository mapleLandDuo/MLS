//
//  AddPostImageCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/15/24.
//

import UIKit

import SnapKit

class AddPostImageCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var callBackMethod: (() -> Void)?

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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension AddPostImageCell {

    func setUp() {
        setUpConstraints()
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.layer.cornerRadius = Constants.defaults.radius
        deleteButton.addTarget(self, action: #selector(didTapButton), for: .primaryActionTriggered)
    }

    func setUpConstraints() {
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButton)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        deleteButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.height.width.equalTo(20)
        }
    }
}

// MARK: - Method
private extension AddPostImageCell {

    @objc
    func didTapButton() {
        callBackMethod?()
    }
}

// MARK: - Bind
extension AddPostImageCell {

    func bind(image: UIImage?) {
        imageView.image = image
    }
}
