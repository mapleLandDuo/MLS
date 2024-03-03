//
//  DropTableViewCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/02.
//

import UIKit

import SnapKit

class DropTableViewCell: UITableViewCell {
    // MARK: - Components
    
    private let leadingView = UIView()
    
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
    
    private let nameTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .semiBold)
        label.textColor = .semanticColor.text.primary
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .medium)
        label.textColor = .semanticColor.text.primary
        label.textAlignment = .right
//        label.isHidden = true
        return label
    }()
    
    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .medium)
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
extension DropTableViewCell {
    func setUp() {
        setUpConstraints()
    }
    
    func setUpConstraints() {
        contentView.addSubview(leadingView)
        leadingView.addSubview(imageBackgroundView)
        imageBackgroundView.addSubview(itemImageView)
        leadingView.addSubview(nameTitleLabel)
        leadingView.addSubview(nameLabel)
        leadingView.addSubview(descriptionTitleLabel)
        leadingView.addSubview(descriptionLabel)
        
        leadingView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(Constants.spacings.sm)
            $0.height.equalTo(72)
        }
        
        imageBackgroundView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.bottom.equalToSuperview().inset(Constants.spacings.md)
            $0.size.equalTo(60)
        }
        
        itemImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(32)
        }
        
        nameTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Constants.spacings.xs)
            $0.leading.equalTo(imageBackgroundView.snp.trailing).offset(Constants.spacings.lg)
            $0.height.equalTo(22)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Constants.spacings.xs)
            $0.leading.equalTo(nameTitleLabel.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(22)
        }
        
        descriptionTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(imageBackgroundView.snp.trailing).offset(Constants.spacings.lg)
            $0.bottom.equalToSuperview().inset(Constants.spacings.xs + Constants.spacings.md)
            $0.height.equalTo(22)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(descriptionTitleLabel.snp.trailing)
            $0.bottom.equalToSuperview().inset(Constants.spacings.xs + Constants.spacings.md)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(22)
        }
    }
}

// MARK: - Bind
extension DropTableViewCell {
    func bind(item: DictDropContent, type: String) {
        if item.name == "메소" {
            descriptionTitleLabel.text = "드롭률"
            nameLabel.isHidden = false
            nameLabel.text = item.level
            itemImageView.image = UIImage(named: "mesoIcon")
        } else {
            nameLabel.isHidden = true
            switch type {
            case "드롭 정보":
                descriptionTitleLabel.text = "드롭률"
                let url = URL(string: "https://maplestory.io/api/gms/62/item/\(item.code)/icon?resize=2")
                itemImageView.kf.setImage(with: url)
                descriptionLabel.text = item.description
            case "정보 완료 조건":
                descriptionTitleLabel.text = "처치 마리수"
                let url = URL(string: "https://maplestory.io/api/gms/62/mob/\(item.code)/render/move?bgColor=")
                itemImageView.kf.setImage(with: url)
                descriptionLabel.text = "\(item.description)마리"
            case "퀘스트 보상":
                descriptionTitleLabel.text = "개수"
                let url = URL(string: "https://maplestory.io/api/gms/62/item/\(item.code)/icon?resize=2")
                itemImageView.kf.setImage(with: url)
                descriptionLabel.text = "\(item.description)개"
            default:
                break
            }
        }
        nameTitleLabel.text = item.name
    }
}
