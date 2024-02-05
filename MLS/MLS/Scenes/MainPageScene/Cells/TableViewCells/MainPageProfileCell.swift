//
//  MainPageProfileCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/22/24.
//

import UIKit

import SnapKit

class MainPageProfileCell: UITableViewCell {
    // MARK: - Components

    private let trailingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.defaults.radius
        return view
    }()

    private let appIconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "AppIcon")
        return view
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title2.font
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension MainPageProfileCell {

    func setUp() {
        contentView.backgroundColor = .systemOrange
        setUpConstraints()
    }

    func setUpConstraints() {
        contentView.addSubview(trailingView)
        trailingView.addSubview(appIconImageView)
        trailingView.addSubview(descriptionLabel)
        
        trailingView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.top.bottom.equalToSuperview().inset(Constants.defaults.vertical)
        }

        appIconImageView.snp.makeConstraints {
            $0.width.height.equalTo(Constants.defaults.blockHeight)
            $0.leading.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.top.bottom.equalToSuperview().inset(Constants.defaults.vertical)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(appIconImageView.snp.top)
            $0.bottom.equalTo(appIconImageView.snp.bottom)
            $0.leading.equalTo(appIconImageView.snp.right).offset(Constants.defaults.horizontal)
            $0.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }
    }
}
// MARK: - Bind
extension MainPageProfileCell {
    func bind(description: String?) {
        guard let description = description else { return }
        descriptionLabel.text = description
        if description == "로그인" {
            descriptionLabel.textAlignment = .center
            descriptionLabel.backgroundColor = .systemGray4
            descriptionLabel.layer.cornerRadius = Constants.defaults.radius
            descriptionLabel.clipsToBounds = true
        } else {
            descriptionLabel.backgroundColor = .clear
            descriptionLabel.textAlignment = .center
        }
    }
}
