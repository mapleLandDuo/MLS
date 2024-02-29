//
//  DictSearchSortedCell.swift
//  MLS
//
//  Created by SeoJunYoung on 2/27/24.
//

import UIKit

import SnapKit

class DictSearchSortedCell: UITableViewCell {
    // MARK: - Components

    private let sortedLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_md, fontType: .regular)
        label.textColor = .semanticColor.text.primary
        return label
    }()

    private let checkImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "checkmark")
        view.tintColor = .semanticColor.icon.primary
        return view
    }()

    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            contentView.backgroundColor = .semanticColor.bg.info
            sortedLabel.textColor = .semanticColor.text.info_bold
            checkImageView.tintColor = .semanticColor.icon.info
        } else {
            contentView.backgroundColor = .white
            sortedLabel.textColor = .semanticColor.text.primary
            checkImageView.tintColor = .semanticColor.icon.primary
        }
    }

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

private extension DictSearchSortedCell {
    func setUp() {
        setUpConstraints()
    }

    func setUpConstraints() {
        contentView.addSubview(sortedLabel)
        contentView.addSubview(checkImageView)

        sortedLabel.snp.makeConstraints {
            $0.height.equalTo(Constants.spacings.xl)
            $0.leading.equalToSuperview().inset(Constants.spacings.xl)
            $0.top.bottom.equalToSuperview().inset(Constants.spacings.lg)
        }

        checkImageView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.centerY.equalToSuperview()
        }
    }
}

extension DictSearchSortedCell {
    func bind(title: String) {
        sortedLabel.text = title
    }
}
