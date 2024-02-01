//
//  MainPageFeature1x4Cell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/14/24.
//

import UIKit

import SnapKit

class MainPageFeatureDefaultsCell: UICollectionViewCell {
    // MARK: - Components

    private let trailingView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        view.layer.cornerRadius = Constants.defaults.radius
        return view
    }()

    private let labelStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Constants.defaults.vertical / 2
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title1.font
        label.textColor = .white
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.body1.font
        label.textColor = .white
        return label
    }()

    private let rightImageView: UIImageView = {
        let view = UIImageView()
        view.tintColor = .white
        return view
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

private extension MainPageFeatureDefaultsCell {
    // MARK: - SetUp

    func setUp() {
        setUpConstraints()
    }

    func setUpConstraints() {
        contentView.addSubview(trailingView)
        trailingView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.top.bottom.equalToSuperview()
        }
        trailingView.addSubview(rightImageView)
        rightImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.width.height.equalTo(Constants.defaults.blockHeight)
            make.centerY.equalToSuperview()
        }
        trailingView.addSubview(labelStackView)
        labelStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Constants.defaults.vertical)
            make.left.equalToSuperview().offset(Constants.defaults.horizontal)
            make.right.equalTo(rightImageView.snp.left)
        }
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(descriptionLabel)
    }
}

extension MainPageFeatureDefaultsCell {
    // MARK: - Bind

    func bind(data: FeatureCellData) {
        titleLabel.text = data.title
        descriptionLabel.text = data.description
        rightImageView.image = data.image
    }
}
