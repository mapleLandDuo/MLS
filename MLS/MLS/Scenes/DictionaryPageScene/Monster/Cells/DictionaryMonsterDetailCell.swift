//
//  DictionaryMonsterDetailCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/28/24.
//

import UIKit

import SnapKit

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

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension DictionaryMonsterDetailCell {

    func setUp() {
        setUpConstraints()
    }

    func setUpConstraints() {
        
        contentView.addSubview(physicalDefenseTitleLabel)
        contentView.addSubview(magicDefenseTitleLabel)
        contentView.addSubview(requiredAccuracyTitleLabel)
        contentView.addSubview(evasionRateTitleLabel)
        contentView.addSubview(physicalDefenseLabel)
        contentView.addSubview(requiredAccuracyLabel)
        contentView.addSubview(magicDefenseLabel)
        contentView.addSubview(evasionRateLabel)
        contentView.addSubview(levelAccuracyLabel)
        contentView.addSubview(bottomSeparatorView)
        
        physicalDefenseTitleLabel.snp.makeConstraints { 
            $0.leading.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.top.equalToSuperview().offset(Constants.defaults.vertical)
        }
        
        magicDefenseTitleLabel.snp.makeConstraints { 
            $0.leading.equalTo(contentView.snp.centerX).offset(Constants.defaults.horizontal)
            $0.top.equalTo(physicalDefenseTitleLabel)
        }
        
        requiredAccuracyTitleLabel.snp.makeConstraints { 
            $0.leading.equalTo(physicalDefenseTitleLabel)
            $0.top.equalTo(physicalDefenseTitleLabel.snp.bottom).offset(Constants.defaults.vertical)
        }
        
        evasionRateTitleLabel.snp.makeConstraints { 
            $0.leading.equalTo(magicDefenseTitleLabel)
            $0.top.equalTo(magicDefenseTitleLabel.snp.bottom).offset(Constants.defaults.vertical)
        }
        
        physicalDefenseLabel.snp.makeConstraints { 
            $0.top.equalTo(physicalDefenseTitleLabel)
            $0.trailing.equalTo(magicDefenseTitleLabel.snp.leading).inset(-Constants.defaults.horizontal * 2)
        }
        
        requiredAccuracyLabel.snp.makeConstraints { 
            $0.top.equalTo(requiredAccuracyTitleLabel)
            $0.trailing.equalTo(evasionRateTitleLabel.snp.leading).inset(-Constants.defaults.horizontal * 2)
        }
        
        magicDefenseLabel.snp.makeConstraints { 
            $0.top.equalTo(magicDefenseTitleLabel)
            $0.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        
        evasionRateLabel.snp.makeConstraints { 
            $0.top.equalTo(evasionRateTitleLabel)
            $0.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        
        levelAccuracyLabel.snp.makeConstraints { 
            $0.top.equalTo(evasionRateLabel.snp.bottom).offset(Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        
        bottomSeparatorView.snp.makeConstraints { 
            $0.top.equalTo(levelAccuracyLabel.snp.bottom).offset(Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - bind
extension DictionaryMonsterDetailCell {

    func bind(item: DictionaryMonster) {
        physicalDefenseLabel.text = "\(item.physicalDefense)"
        magicDefenseLabel.text = "\(item.magicDefense)"
        requiredAccuracyLabel.text = "\(item.requiredAccuracy)"
        evasionRateLabel.text = "\(item.evasionRate)"
        levelAccuracyLabel.text = item.levelAccuracy
    }
}
