//
//  MainPageFeatureListPostCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/15/24.
//

import UIKit

import SnapKit

class MainPageFeatureListPostCell: UITableViewCell {
    // MARK: - Components

    private let trailingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = Constants.defaults.radius
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.body2.font
        label.textColor = .black
        label.numberOfLines = 1
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
private extension MainPageFeatureListPostCell {

    func setUp() {
        contentView.backgroundColor = .white
        setUpConstraints()
    }

    func setUpConstraints() {
        contentView.addSubview(trailingView)
        trailingView.addSubview(titleLabel)
        
        trailingView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(Constants.defaults.vertical)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.top.bottom.equalToSuperview().inset(Constants.defaults.vertical)
        }
    }
}

// MARK: - Bind
extension MainPageFeatureListPostCell {

    func bind(text: String) {
        titleLabel.text = text
    }
}
