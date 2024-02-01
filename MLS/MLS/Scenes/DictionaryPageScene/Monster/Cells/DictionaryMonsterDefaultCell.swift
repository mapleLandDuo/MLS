//
//  DictionaryMonsterDefaultCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/28/24.
//

import UIKit

class DictionaryMonsterDefaultCell: UITableViewCell {
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

    private let expTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Exp"
        label.font = Typography.title3.font
        return label
    }()

    private let expLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title3.font
        return label
    }()

    private let hpTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hp"
        label.font = Typography.title3.font
        return label
    }()

    private let hpLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title3.font
        return label
    }()

    private let mpTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Mp"
        label.font = Typography.title3.font
        return label
    }()

    private let mpLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title3.font
        return label
    }()

    private let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
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

private extension DictionaryMonsterDefaultCell {
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
        contentView.addSubview(expTitleLabel)
        expTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.centerX).offset(Constants.defaults.horizontal)
            make.top.equalTo(levelTitleLabel)
        }
        contentView.addSubview(hpTitleLabel)
        hpTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(levelTitleLabel)
            make.top.equalTo(levelTitleLabel.snp.bottom).offset(Constants.defaults.vertical)
        }
        contentView.addSubview(mpTitleLabel)
        mpTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(expTitleLabel)
            make.top.equalTo(expTitleLabel.snp.bottom).offset(Constants.defaults.vertical)
        }
        contentView.addSubview(levelLabel)
        levelLabel.snp.makeConstraints { make in
            make.top.equalTo(levelTitleLabel)
            make.right.equalTo(expTitleLabel.snp.left).inset(-Constants.defaults.horizontal * 2)
        }
        contentView.addSubview(hpLabel)
        hpLabel.snp.makeConstraints { make in
            make.top.equalTo(hpTitleLabel)
            make.right.equalTo(mpTitleLabel.snp.left).inset(-Constants.defaults.horizontal * 2)
        }
        contentView.addSubview(expLabel)
        expLabel.snp.makeConstraints { make in
            make.top.equalTo(expTitleLabel)
            make.right.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        contentView.addSubview(mpLabel)
        mpLabel.snp.makeConstraints { make in
            make.top.equalTo(mpTitleLabel)
            make.right.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        contentView.addSubview(bottomSeparatorView)
        bottomSeparatorView.snp.makeConstraints { make in
            make.top.equalTo(mpLabel.snp.bottom).offset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
}

extension DictionaryMonsterDefaultCell {
    // MARK: - bind

    func bind(item: DictionaryMonster) {
        levelLabel.text = "\(item.level)"
        expLabel.text = "\(item.exp)"
        hpLabel.text = "\(item.hp)"
        mpLabel.text = "\(item.mp)"
    }
}
