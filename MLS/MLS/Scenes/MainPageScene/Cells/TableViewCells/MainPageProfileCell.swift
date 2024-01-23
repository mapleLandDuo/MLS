//
//  MainPageProfileCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/22/24.
//

import Foundation
import UIKit

class MainPageProfileCell: UITableViewCell {
    
    // MARK: - Components

    private let trailingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.defaults.radius
        return view
    }()
    
    private let appIconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "AppIcon")
        return view
    }()
    
    private let discriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "temptemp"
        label.font = Typography.title2.font
//        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MainPageProfileCell {
    // MARK: - SetUp

    func setUp() {
        contentView.backgroundColor = .systemOrange
        setUpConstraints()
    }
    
    func setUpConstraints() {
        contentView.addSubview(trailingView)
        trailingView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.top.bottom.equalToSuperview().inset(Constants.defaults.vertical)
        }
        trailingView.addSubview(appIconImageView)
        appIconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.defaults.blockHeight)
            make.left.equalToSuperview().inset(Constants.defaults.horizontal)
            make.top.bottom.equalToSuperview().inset(Constants.defaults.vertical)
        }
        trailingView.addSubview(discriptionLabel)
        discriptionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(appIconImageView.snp.centerY)
            make.left.equalTo(appIconImageView.snp.right).offset(Constants.defaults.horizontal)
            make.right.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        
    }
}

extension MainPageProfileCell {
    func bind(discription: String?) {
        guard let discription = discription else { return }
        discriptionLabel.text = discription
        if discription == "로그인" {
            discriptionLabel.snp.remakeConstraints { make in
                make.centerY.centerX.equalToSuperview()
            }
        }
        
    }

}
