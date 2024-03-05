//
//  PopularTableViewCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/04.
//

import UIKit

import SnapKit

class PopularTableViewCell: UITableViewCell {
    // MARK: - Components
    
    private let leadingView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()
    
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
        label.font = .customFont(fontSize: .body_sm, fontType: .semiBold)
        label.textColor = .semanticColor.text.primary
        return label
    }()
    
    private let indexLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .medium)
        label.textColor = .semanticColor.text.primary
        label.textAlignment = .center
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
extension PopularTableViewCell {
    func setUp() {
        setUpConstraints()
    }
    
    func setUpConstraints() {
        contentView.addSubview(leadingView)
        leadingView.addSubview(indexLabel)
        leadingView.addSubview(imageBackgroundView)
        imageBackgroundView.addSubview(itemImageView)
        leadingView.addSubview(nameLabel)
        
        
        leadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(Constants.spacings.md)
        }
        
        indexLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Constants.spacings.sm)
            $0.centerY.equalTo(imageBackgroundView)
            $0.width.equalTo(33)
            $0.height.equalTo(40)
        }
        
        
        imageBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(indexLabel.snp.trailing).offset(Constants.spacings.xs)
            $0.bottom.equalToSuperview()
            $0.size.equalTo(60)
        }
        
        itemImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(32)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(imageBackgroundView.snp.trailing).offset(Constants.spacings.lg)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(imageBackgroundView)
            $0.height.equalTo(22)
        }
    }
}

// MARK: - Bind
extension PopularTableViewCell {
    func bind(item: DictSectionData, index: Int, rank: Int) {
        nameLabel.text = item.title
        indexLabel.text = String(index + 1)
        
        if item.type == .item {
            let url = URL(string: "https://maplestory.io/api/gms/62/item/\(item.image)/icon?resize=2")
            itemImageView.kf.setImage(with: url)
        } else {
            let url = URL(string: "https://maplestory.io/api/gms/62/mob/\(item.image)/render/move?bgColor=")
            itemImageView.kf.setImage(with: url)
        }
        
        if rank == 0 {
            indexLabel.textColor = .semanticColor.text.interactive.primary
        } else {
            indexLabel.textColor = .semanticColor.text.primary
        }
    }
}
