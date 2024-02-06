//
//  AddPostImageChoiceCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/15/24.
//

import UIKit

import SnapKit

class AddPostImageChoiceCell: UICollectionViewCell {
    // MARK: - Components

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = Constants.defaults.vertical / 2
        return view
    }()

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "photo.on.rectangle.angled")
        view.tintColor = .systemGray4
        return view
    }()

    private let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray4
        label.font = Typography.body2.font
        label.text = "0/5"
        return label
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
private extension AddPostImageChoiceCell {

    func setUp() {
        setUpConstraints()
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.layer.cornerRadius = Constants.defaults.radius
    }

    func setUpConstraints() {
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(countLabel)
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(Constants.defaults.blockHeight)
        }

    }
}

// MARK: - Bind
extension AddPostImageChoiceCell {

    func bind(count: Int?) {
        guard let count = count else { return }
        countLabel.text = "\(count)/5"
    }
}
