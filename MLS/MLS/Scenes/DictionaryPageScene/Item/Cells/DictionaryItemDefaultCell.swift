//
//  DictionaryItemDefaultCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/29/24.
//

import UIKit

class DictionaryItemDefaultCell: UITableViewCell {
    // MARK: - Components

    private let levelTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Level"
        label.font = Typography.title3.font
        return label
    }()

    private let levelLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title3.font
        return label
    }()

    private let divisionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "분류"
        label.font = Typography.title3.font
        return label
    }()

    private let divisionLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title3.font
        return label
    }()

    private let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
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

private extension DictionaryItemDefaultCell {
    // MARK: - SetUp

    func setUp() {
        setUpConstraints()
    }

    func setUpConstraints() {
        contentView.addSubview(levelTitleLabel)
        levelTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(Constants.defaults.horizontal)
            make.top.equalToSuperview().offset(Constants.defaults.vertical)
        }
        contentView.addSubview(divisionTitleLabel)
        divisionTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.centerX).offset(Constants.defaults.horizontal)
            make.top.equalTo(levelTitleLabel)
        }
        contentView.addSubview(levelLabel)
        levelLabel.snp.makeConstraints { make in
            make.top.equalTo(levelTitleLabel)
            make.right.equalTo(divisionTitleLabel.snp.left).inset(-Constants.defaults.horizontal * 2)
        }
        contentView.addSubview(divisionLabel)
        divisionLabel.snp.makeConstraints { make in
            make.top.equalTo(levelLabel)
            make.right.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        contentView.addSubview(bottomSeparatorView)
        bottomSeparatorView.snp.makeConstraints { make in
            make.top.equalTo(divisionTitleLabel.snp.bottom).offset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
}

extension DictionaryItemDefaultCell {
    // MARK: - bind

    func bind(item: DictionaryItem) {
        levelLabel.text = "\(item.level)"
        divisionLabel.text = "\(item.division)/\(item.mainCategory)/\(item.subCategory)"
    }
}
