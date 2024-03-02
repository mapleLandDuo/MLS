//
//  DictHorizontalCollectionViewCell.swift
//  MLS
//
//  Created by SeoJunYoung on 2/19/24.
//

import UIKit

import SnapKit

class DictHorizontalCollectionViewCell: UICollectionViewCell {
    
    private let imageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .themeColor(color: .brand_primary, value: .value_50)
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .semiBold)
        label.textColor = .semanticColor.text.primary
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .regular)
        label.textColor = .semanticColor.text.secondary
        return label
    }()
    
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .medium)
        label.textColor = .semanticColor.text.primary
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

// MARK: - SetUp
private extension DictHorizontalCollectionViewCell {
    func setUp() {
        setUpConstraints()
    }
    
    func setUpConstraints() {
        contentView.addSubview(imageBackgroundView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(levelLabel)
        imageBackgroundView.addSubview(imageView)
        
        imageBackgroundView.snp.makeConstraints {
            $0.width.height.equalTo(120)
            $0.top.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageBackgroundView.snp.bottom).offset(Constants.spacings.xs)
            $0.height.equalTo(22)
            $0.leading.trailing.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.spacings.xs_2)
            $0.height.equalTo(22)
            $0.leading.equalToSuperview()
        }
        
        levelLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.spacings.xs_2)
            $0.leading.equalTo(subTitleLabel.snp.trailing).offset(Constants.spacings.xs)
            $0.height.equalTo(22)
            $0.trailing.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(Constants.spacings.xl_5)
        }
    }
}

// MARK: - Bind
extension DictHorizontalCollectionViewCell {
    func bind(data: DictSectionData) {
        titleLabel.text = data.title
        switch data.type {
        case .item:
            let url = URL(string: "https://maplestory.io/api/gms/62/item/\(data.image)/icon?resize=2")
            imageView.kf.setImage(with: url)
            subTitleLabel.text = "필요레벨"
        case .monster:
            let url = URL(string: "https://maplestory.io/api/gms/62/mob/\(data.image)/render/move?bgColor=")
            imageView.kf.setImage(with: url)
            subTitleLabel.text = "레벨"
        case .map:
            let url = URL(string: "https://mapledb.kr/Assets/image/minimaps/\(data.image).png")
            imageView.kf.setImage(with: url)
            subTitleLabel.text = "필요레벨"
        case .npc:
            let url = URL(string: "https://maplestory.io/api/gms/62/npc/\(data.image)/icon?resize=2")
            imageView.kf.setImage(with: url)
            subTitleLabel.text = "필요레벨"
        case .quest:
            let url = URL(string: "https://maplestory.io/api/gms/62/npc/\(data.image)/icon")
            imageView.kf.setImage(with: url)
            subTitleLabel.text = "필요레벨"
        }
        levelLabel.text = data.level
    }
}
