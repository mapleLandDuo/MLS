//
//  MainPageProfileCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/22/24.
//

import UIKit

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

private extension MainPageProfileCell {
    // MARK: - SetUp

    func setUp() {
        contentView.backgroundColor = .systemOrange
        setUpConstraints()
    }

    func setUpConstraints() {
        contentView.addSubview(trailingView)
        trailingView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.top.bottom.equalToSuperview().inset(Constants.defaults.vertical)
        }
        trailingView.addSubview(appIconImageView)
        appIconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.defaults.blockHeight)
            make.left.equalToSuperview().inset(Constants.defaults.horizontal)
            make.top.bottom.equalToSuperview().inset(Constants.defaults.vertical)
        }
        trailingView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(appIconImageView.snp.top)
            make.bottom.equalTo(appIconImageView.snp.bottom)
            make.left.equalTo(appIconImageView.snp.right).offset(Constants.defaults.horizontal)
            make.right.equalToSuperview().inset(Constants.defaults.horizontal)
        }
    }
}

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
