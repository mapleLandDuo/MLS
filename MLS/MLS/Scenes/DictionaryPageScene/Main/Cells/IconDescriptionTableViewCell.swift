//
//  IconDescriptionTableViewCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/31/24.
//

import Foundation
import UIKit

class IconDescriptionTableViewCell: UITableViewCell {
    // MARK: - Componetns
    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.cornerRadius = Constants.defaults.radius
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title3.font
        return label
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension IconDescriptionTableViewCell {
    // MARK: - SetUp

    func setUp() {
        setUpConstraints()
    }
    func setUpConstraints() {
        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.defaults.blockHeight)
            make.top.equalToSuperview().inset(Constants.defaults.vertical)
            make.left.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView.snp.centerY)
            make.right.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        contentView.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
}

extension IconDescriptionTableViewCell {
    // MARK: - bind
    func bind(iconUrl: URL?, description: String) {
        iconImageView.kf.setImage(with: iconUrl)
        descriptionLabel.text = description
    }
}
