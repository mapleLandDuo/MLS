//
//  DictionaryMonsterDropTableCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/29/24.
//

import UIKit

import SnapKit

class DictionaryGraySeparatorOneLineCell: UITableViewCell {
    // MARK: - Components

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title3.font
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title3.font
        return label
    }()

    private let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()

    private let stackView: UIStackView = {
        let view = UIStackView()
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
private extension DictionaryGraySeparatorOneLineCell {
    func setUp() {
        setUpConstraints()
    }

    func setUpConstraints() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(descriptionLabel)
        contentView.addSubview(bottomSeparatorView)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }

        bottomSeparatorView.snp.makeConstraints { 
            $0.top.equalTo(stackView.snp.bottom).offset(Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - bind
extension DictionaryGraySeparatorOneLineCell {

    func bind(data: DictionaryNameDescription) {
        nameLabel.text = data.name
        descriptionLabel.text = data.description
    }

    func bind(name: String, description: String) {
        nameLabel.text = name
        descriptionLabel.text = description
    }
}
