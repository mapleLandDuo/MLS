//
//  DictionaryGraySeparatorDescriptionCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/30/24.
//

import UIKit

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
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        contentView.addSubview(bottomSeparatorView)
        bottomSeparatorView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - bind
extension DictionaryGraySeparatorDescriptionCell {

    func bind(data: DictionaryNameDescription) {
        descriptionLabel.text = data.description
    }
}
