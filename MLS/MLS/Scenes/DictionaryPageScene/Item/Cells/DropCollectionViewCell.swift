//
//  DropCollectionViewCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/01.
//

import UIKit

import SnapKit

class DropCollectionViewCell: UICollectionViewCell {
    // MARK: Properties
    private var items: DictDropContent?
    
    // MARK: Components
    private let imageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .themeColor(color: .brand_primary, value: .value_50)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.themeColor(color: .brand_primary, value: .value_200)?.cgColor
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .semiBold)
        label.textColor = .semanticColor.text.primary
        label.numberOfLines = 2
        return label
    }()
    
    private let levelTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .regular)
        label.textColor = .semanticColor.text.secondary
        label.text = "레벨"
        return label
    }()
    
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .medium)
        label.textColor = .semanticColor.text.primary
        label.textAlignment = .right
        return label
    }()
    
    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .regular)
        label.textColor = .semanticColor.text.secondary
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .medium)
        label.textColor = .semanticColor.text.interactive.primary
        label.textAlignment = .right
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
private extension DropCollectionViewCell {
    func setUp() {
        setUpConstraints()
    }
    
    func setUpConstraints() {
        contentView.addSubview(imageBackgroundView)
        imageBackgroundView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        
        contentView.addSubview(levelTitleLabel)
        contentView.addSubview(levelLabel)
        contentView.addSubview(descriptionTitleLabel)
        contentView.addSubview(descriptionLabel)
        
        imageBackgroundView.snp.makeConstraints {
            $0.width.height.equalTo(120)
            $0.top.leading.trailing.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(80)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(imageBackgroundView.snp.bottom).offset(Constants.spacings.xs)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        levelTitleLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(Constants.spacings.xs_2)
            $0.height.equalTo(22)
            $0.leading.equalToSuperview()
        }
        
        levelLabel.snp.makeConstraints {
            $0.top.equalTo(levelTitleLabel)
            $0.leading.equalTo(levelTitleLabel.snp.trailing).offset(Constants.spacings.xs)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(22)
        }
        
        descriptionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(levelTitleLabel.snp.bottom).offset(Constants.spacings.xs_2)
            $0.height.equalTo(22)
            $0.leading.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(levelTitleLabel.snp.bottom).offset(Constants.spacings.xs_2)
            $0.leading.equalTo(descriptionTitleLabel.snp.trailing).offset(Constants.spacings.xs)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(22)
        }
    }
}

// MARK: - Bind
extension DropCollectionViewCell {
    func bind(data: DictDropContent, type: DictType) {
        levelTitleLabel.isHidden = false
        levelLabel.isHidden = false
        descriptionTitleLabel.isHidden = false
        descriptionLabel.isHidden = false
        
        nameLabel.text = data.name
        levelLabel.text = data.level
        descriptionLabel.text = data.description
        switch type {
        case .item:
            let url = URL(string: "https://maplestory.io/api/gms/62/item/\(data.code)/icon?resize=2")
            imageView.kf.setImage(with: url)
            descriptionTitleLabel.text = "드롭률"
        case .monster:
            let url = URL(string: "https://maplestory.io/api/gms/62/mob/\(data.code)/render/move?bgColor=")
            let secondUrl = URL(string: "https://maplestory.io/api/kms/284/mob/\(data.code)/icon?resize=2")
            imageView.kf.setImage(with: url) { [weak self] result in
                switch result {
                case .failure(_) :
                    self?.imageView.kf.setImage(with: secondUrl)
                default :
                    break
                }
            }
            if data.description.contains("%") {
                descriptionTitleLabel.text = "드롭률"
            } else {
                descriptionTitleLabel.text = "출현 몬스터 수"
            }
        case .npc:
            let url = URL(string: "https://maplestory.io/api/gms/62/npc/\(data.code)/icon?resize=2")
            imageView.kf.setImage(with: url)
            levelTitleLabel.isHidden = true
            levelLabel.isHidden = true
            descriptionTitleLabel.isHidden = true
            descriptionLabel.isHidden = true
        default:
            break
        }
    }
}
