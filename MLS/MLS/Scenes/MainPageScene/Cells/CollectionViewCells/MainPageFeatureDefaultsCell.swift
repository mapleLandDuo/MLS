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

// MARK: - SetUp
private extension MainPageFeatureDefaultsCell {

    func setUp() {
        setUpConstraints()
    }

    func setUpConstraints() {
        contentView.addSubview(trailingView)
        trailingView.addSubview(rightImageView)
        trailingView.addSubview(labelStackView)
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(descriptionLabel)
        
        trailingView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.top.bottom.equalToSuperview()
        }
        rightImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.width.height.equalTo(Constants.defaults.blockHeight)
            $0.centerY.equalToSuperview()
        }
        labelStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.defaults.vertical)
            $0.leading.equalToSuperview().offset(Constants.defaults.horizontal)
            $0.trailing.equalTo(rightImageView.snp.leading)
        }

    }
}

// MARK: - Bind
extension MainPageFeatureDefaultsCell {

    func bind(data: FeatureCellData) {
        titleLabel.text = data.title
        descriptionLabel.text = data.description
        rightImageView.image = data.image
    }
}
