//
//  DictSearchDataCell.swift
//  MLS
//
//  Created by SeoJunYoung on 2/24/24.
//

import UIKit

import SnapKit
import Kingfisher

class DictSearchDataCell: UITableViewCell {
    // MARK: - Components
    
    private let imageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .themeColor(color: .brand_primary, value: .value_50)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.themeColor(color: .brand_primary, value: .value_200)?.cgColor
        return view
    }()
    
    private let itemImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .medium)
        label.textColor = .semanticColor.text.primary
        return label
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
extension DictSearchDataCell {
    
    func setUp() {
        setUpConstraints()
    }
    
    func setUpConstraints() {
        contentView.addSubview(imageBackgroundView)
        contentView.addSubview(nameLabel)
        imageBackgroundView.addSubview(itemImageView)
        
        imageBackgroundView.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.leading.equalToSuperview().inset(Constants.spacings.xl)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(Constants.spacings.md)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(imageBackgroundView.snp.centerY)
            $0.leading.equalTo(imageBackgroundView.snp.trailing).offset(Constants.spacings.lg)
        }
        
        itemImageView.snp.makeConstraints {
            $0.width.height.equalTo(Constants.spacings.xl_2)
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - Bind
extension DictSearchDataCell {
    func bind(data: DictSectionData, keyword: String) {
        let fullText = data.title
        let attribtuedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: keyword)
        attribtuedString.addAttribute(.foregroundColor, value: UIColor.semanticColor.text.interactive.primary, range: range)
        nameLabel.attributedText = attribtuedString
        switch data.type {
        case .monster:
            let url = URL(string: "https://maplestory.io/api/gms/62/mob/\(data.image)/render/move?bgColor=")
            let secondUrl = URL(string: "https://maplestory.io/api/kms/284/mob/\(data.image)/icon?resize=2")
            itemImageView.kf.setImage(with: url) { [weak self] result in
                switch result {
                case .failure(_) :
                    print(#function)
                    self?.itemImageView.kf.setImage(with: secondUrl)
                default :
                    print(#function)
                }
            }
        case .item:
            let url = URL(string: "https://maplestory.io/api/gms/62/item/\(data.image)/icon?resize=2")
            itemImageView.kf.setImage(with: url)
        case .map:
            itemImageView.image = UIImage(named: "Map-Image")
        case .npc:
            let url = URL(string: "https://maplestory.io/api/gms/62/npc/\(data.image)/icon?resize=2")
            itemImageView.kf.setImage(with: url)
        case .quest:
            itemImageView.image = UIImage(named: "quest-Image")
        }
    }
}
