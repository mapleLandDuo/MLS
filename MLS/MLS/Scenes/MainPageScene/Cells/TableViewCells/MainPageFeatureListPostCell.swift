//
//  MainPageFeatureListPostCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/15/24.
//

import UIKit
import SnapKit

class MainPageFeatureListPostCell: UITableViewCell {
    // MARK: - Componetns
    
    private let trailingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.systemOrange.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = Constants.defaults.radius
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.body2.font
        label.textColor = .black
        label.numberOfLines = 1
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

extension MainPageFeatureListPostCell {
    // MARK: - Bind
    func bind(text: String) {
        titleLabel.text = text
//        titleLabel.startTextFlowAnimation(superViewWidth: Constants.screenWidth - (Constants.defaults.horizontal * 4))
    }
}

private extension MainPageFeatureListPostCell {
    // MARK: - SetUp
    
    func setUp() {
        contentView.backgroundColor = .white
        setUpConstraints()
    }
    

    func setUpConstraints() {
        contentView.addSubview(trailingView)
        trailingView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
//            make.height.equalTo(Constants.defaults.blockHeight)
            make.bottom.equalToSuperview().inset(Constants.defaults.vertical)
        }
        trailingView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.top.bottom.equalToSuperview().inset(Constants.defaults.vertical)
        }
    }
}
