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
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "temptemp"
        label.font = Typography.title2.font
        return label
    }()
    
    private let appVersionLabel: UILabel = {
        let label = UILabel()
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return label }
        label.text = "V" + version
        label.textColor = .systemOrange
        label.font = Typography.body2.font
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
        setUpConstraints()
        contentView.backgroundColor = .systemOrange
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
        trailingView.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(appIconImageView.snp.top)
            make.left.equalTo(appIconImageView.snp.right).offset(Constants.defaults.horizontal)
        }
        trailingView.addSubview(appVersionLabel)
        appVersionLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(Constants.defaults.vertical / 2)
            make.left.equalTo(nickNameLabel.snp.left)
        }
    }
}
