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
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .red
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .semiBold)
        label.text = "블루어쩌구저쩌구저쩌구"
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .regular)
        label.text = "필요레벨"
        return label
    }()
    
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .medium)
        label.text = "58"
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
