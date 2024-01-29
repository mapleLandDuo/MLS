//
//  DictionaryMonsterDetailCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/28/24.
//

import Foundation
import UIKit

class DictionaryMonsterDetailCell: UITableViewCell {
    // MARK: - Components
    
    private let physicalDefenseTitleLabel: UILabel = {
       let label = UILabel()
        label.text = "물리 방어력"
        label.font = Typography.title3.font
        return label
    }()
    private let physicalDefenseLabel: UILabel = {
       let label = UILabel()
        label.font = Typography.title3.font
        return label
    }()
    private let magicDefenseTitleLabel: UILabel = {
       let label = UILabel()
        label.text = "마법 방어력"
        label.font = Typography.title3.font
        return label
    }()
    private let magicDefenseLabel: UILabel = {
       let label = UILabel()
        label.font = Typography.title3.font
        return label
    }()
    private let requiredAccuracyTitleLabel: UILabel = {
       let label = UILabel()
        label.text = "필요 명중률"
        label.font = Typography.title3.font
        return label
    }()
    private let requiredAccuracyLabel: UILabel = {
       let label = UILabel()
        label.font = Typography.title3.font
        return label
    }()
    private let evasionRateTitleLabel: UILabel = {
       let label = UILabel()
        label.text = "회피율"
        label.font = Typography.title3.font
        return label
    }()
    private let evasionRateLabel: UILabel = {
       let label = UILabel()
        label.font = Typography.title3.font
        return label
    }()
    private let levelAccuracyLabel: UILabel = {
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DictionaryMonsterDetailCell {
    // MARK: - SetUp
    func setUp() {
        setUpConstraints()
    }
    func setUpConstraints() {
        contentView.addSubview(physicalDefenseTitleLabel)
        physicalDefenseTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(Constants.defaults.horizontal)
            make.top.equalToSuperview().offset(Constants.defaults.vertical)
        }
        contentView.addSubview(magicDefenseTitleLabel)
        magicDefenseTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.centerX).offset(Constants.defaults.horizontal)
            make.top.equalTo(physicalDefenseTitleLabel)
        }
        contentView.addSubview(requiredAccuracyTitleLabel)
        requiredAccuracyTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(physicalDefenseTitleLabel)
            make.top.equalTo(physicalDefenseTitleLabel.snp.bottom).offset(Constants.defaults.vertical)
        }
        contentView.addSubview(evasionRateTitleLabel)
        evasionRateTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(magicDefenseTitleLabel)
            make.top.equalTo(magicDefenseTitleLabel.snp.bottom).offset(Constants.defaults.vertical)
        }
        contentView.addSubview(physicalDefenseLabel)
        physicalDefenseLabel.snp.makeConstraints { make in
            make.top.equalTo(physicalDefenseTitleLabel)
            make.right.equalTo(magicDefenseTitleLabel.snp.left).inset(-Constants.defaults.horizontal * 2)
        }
        contentView.addSubview(requiredAccuracyLabel)
        requiredAccuracyLabel.snp.makeConstraints { make in
            make.top.equalTo(requiredAccuracyTitleLabel)
            make.right.equalTo(evasionRateTitleLabel.snp.left).inset(-Constants.defaults.horizontal * 2)
        }
        contentView.addSubview(magicDefenseLabel)
        magicDefenseLabel.snp.makeConstraints { make in
            make.top.equalTo(magicDefenseTitleLabel)
            make.right.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        contentView.addSubview(evasionRateLabel)
        evasionRateLabel.snp.makeConstraints { make in
            make.top.equalTo(evasionRateTitleLabel)
            make.right.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        contentView.addSubview(levelAccuracyLabel)
        levelAccuracyLabel.snp.makeConstraints { make in
            make.top.equalTo(evasionRateLabel.snp.bottom).offset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        contentView.addSubview(bottomSeparatorView)
        bottomSeparatorView.snp.makeConstraints { make in
            make.top.equalTo(levelAccuracyLabel.snp.bottom).offset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
}

extension DictionaryMonsterDetailCell {
    // MARK: - bind
    func bind(item: DictionaryMonster) {
        physicalDefenseLabel.text = "\(item.level)"
        magicDefenseLabel.text = "\(item.exp)"
        requiredAccuracyLabel.text = "\(item.hp)"
        evasionRateLabel.text = "\(item.mp)"
        levelAccuracyLabel.text = item.levelAccuracy
    }
}
