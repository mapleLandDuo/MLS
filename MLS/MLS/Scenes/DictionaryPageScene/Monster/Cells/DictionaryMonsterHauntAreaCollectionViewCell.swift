//
//  DictionaryMonsterHauntAreaCollectionViewCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/28/24.
//

import UIKit

import SnapKit

class DictionaryMonsterHauntAreaCollectionViewCell: UICollectionViewCell {
    // MARK: - Components

    private let label: UILabel = {
        let label = UILabel()
        label.font = Typography.button.font
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DictionaryMonsterHauntAreaCollectionViewCell {
    // MARK: - SetUp

    func setUp() {
        setUpConstraints()
        contentView.backgroundColor = .systemOrange
        contentView.layer.cornerRadius = Constants.defaults.blockHeight / 2
        contentView.clipsToBounds = true
    }

    func setUpConstraints() {
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension DictionaryMonsterHauntAreaCollectionViewCell {
    // MARK: - bind

    func bind(area: String) {
        label.text = area
    }
}
