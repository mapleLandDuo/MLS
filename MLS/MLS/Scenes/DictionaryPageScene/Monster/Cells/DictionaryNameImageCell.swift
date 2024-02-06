//
//  DictionaryNameImageCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/28/24.
//

import UIKit

import Kingfisher
import SnapKit

class DictionaryNameImageCell: UITableViewCell {
    // MARK: - Components

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title1.font
        label.textAlignment = .center
        return label
    }()

    private let dictionaryImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
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
private extension DictionaryNameImageCell {

    func setUp() {
        setUpConstraints()
    }

    func setUpConstraints() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(dictionaryImageView)
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        dictionaryImageView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(Constants.defaults.vertical)
            $0.width.height.equalTo(Constants.screenWidth / 3)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - bind
extension DictionaryNameImageCell {

    func bind(item: DictionaryMonster) {
        nameLabel.text = item.name
        let url = URL(string: "https://maplestory.io/api/gms/62/mob/\(item.code)/render/move?bgColor=")
        dictionaryImageView.kf.setImage(with: url)
    }

    func bind(item: DictionaryItem) {
        nameLabel.text = item.name
        let url = URL(string: "https://maplestory.io/api/gms/62/item/\(item.code)/icon")
        dictionaryImageView.kf.setImage(with: url)
    }
}
