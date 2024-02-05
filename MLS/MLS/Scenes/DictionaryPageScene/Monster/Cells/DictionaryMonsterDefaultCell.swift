//
//  DictionaryMonsterDefaultCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/28/24.
//

import UIKit

import SnapKit

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

// MARK: - SetUp
private extension DictionaryMonsterDefaultCell {

    func setUp() {
        setUpConstraints()
    }

    func setUpConstraints() {
        
        contentView.addSubview(levelTitleLabel)
        contentView.addSubview(expTitleLabel)
        contentView.addSubview(hpTitleLabel)
        contentView.addSubview(mpTitleLabel)
        contentView.addSubview(levelLabel)
        contentView.addSubview(hpLabel)
        contentView.addSubview(expLabel)
        contentView.addSubview(mpLabel)
        contentView.addSubview(bottomSeparatorView)
        
        levelTitleLabel.snp.makeConstraints { 
            $0.leading.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.top.equalToSuperview().offset(Constants.defaults.vertical)
        }
        expTitleLabel.snp.makeConstraints { 
            $0.leading.equalTo(contentView.snp.centerX).offset(Constants.defaults.horizontal)
            $0.top.equalTo(levelTitleLabel)
        }
        hpTitleLabel.snp.makeConstraints { 
            $0.leading.equalTo(levelTitleLabel)
            $0.top.equalTo(levelTitleLabel.snp.bottom).offset(Constants.defaults.vertical)
        }
        mpTitleLabel.snp.makeConstraints { 
            $0.leading.equalTo(expTitleLabel)
            $0.top.equalTo(expTitleLabel.snp.bottom).offset(Constants.defaults.vertical)
        }
        levelLabel.snp.makeConstraints { 
            $0.top.equalTo(levelTitleLabel)
            $0.trailing.equalTo(expTitleLabel.snp.leading).inset(-Constants.defaults.horizontal * 2)
        }
        hpLabel.snp.makeConstraints { 
            $0.top.equalTo(hpTitleLabel)
            $0.trailing.equalTo(mpTitleLabel.snp.leading).inset(-Constants.defaults.horizontal * 2)
        }

        expLabel.snp.makeConstraints { 
            $0.top.equalTo(expTitleLabel)
            $0.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }

        mpLabel.snp.makeConstraints { 
            $0.top.equalTo(mpTitleLabel)
            $0.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }

        bottomSeparatorView.snp.makeConstraints { 
            $0.top.equalTo(mpLabel.snp.bottom).offset(Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - bind
extension DictionaryMonsterDefaultCell {

    func bind(item: DictionaryMonster) {
        levelLabel.text = "\(item.level)"
        expLabel.text = "\(item.exp)"
        hpLabel.text = "\(item.hp)"
        mpLabel.text = "\(item.mp)"
    }
}
