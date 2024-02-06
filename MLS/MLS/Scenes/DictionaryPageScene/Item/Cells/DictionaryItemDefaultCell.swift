//
//  DictionaryItemDefaultCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/29/24.
//

import UIKit

import SnapKit

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

// MARK: - SetUp
private extension DictionaryItemDefaultCell {

    func setUp() {
        setUpConstraints()
    }

    func setUpConstraints() {
        contentView.addSubview(levelTitleLabel)
        contentView.addSubview(divisionTitleLabel)
        contentView.addSubview(levelLabel)
        contentView.addSubview(divisionLabel)
        contentView.addSubview(bottomSeparatorView)
        
        levelTitleLabel.snp.makeConstraints { 
            $0.leading.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.top.equalToSuperview().offset(Constants.defaults.vertical)
        }

        divisionTitleLabel.snp.makeConstraints { 
            $0.leading.equalTo(contentView.snp.centerX).offset(Constants.defaults.horizontal)
            $0.top.equalTo(levelTitleLabel)
        }
        levelLabel.snp.makeConstraints { 
            $0.top.equalTo(levelTitleLabel)
            $0.trailing.equalTo(divisionTitleLabel.snp.leading).inset(-Constants.defaults.horizontal * 2)
        }
        divisionLabel.snp.makeConstraints { 
            $0.top.equalTo(levelLabel)
            $0.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        bottomSeparatorView.snp.makeConstraints { 
            $0.top.equalTo(divisionTitleLabel.snp.bottom).offset(Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - bind
extension DictionaryItemDefaultCell {

    func bind(item: DictionaryItem) {
        levelLabel.text = "\(item.level)"
        divisionLabel.text = "\(item.division)/\(item.mainCategory)/\(item.subCategory)"
    }
}
