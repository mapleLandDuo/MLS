//
//  DictionaryGraySeparatorDescriptionCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/30/24.
//

import UIKit

import SnapKit

class DictionaryGraySeparatorDescriptionCell: UITableViewCell {
    // MARK: - Components

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title3.font
        label.textAlignment = .center
        label.numberOfLines = 0
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
private extension DictionaryGraySeparatorDescriptionCell {
    func setUp() {
        setUpConstraints()
    }

    func setUpConstraints() {
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(bottomSeparatorView)
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }

        bottomSeparatorView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - bind
extension DictionaryGraySeparatorDescriptionCell {

    func bind(data: DictionaryNameDescription) {
        descriptionLabel.text = data.description
    }
}
