//
//  IconDescriptionTableViewCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/31/24.
//

import Foundation
import UIKit

class IconDescriptionTableViewCell: UITableViewCell {
    // MARK: - Componetns
    
    private let leftButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.defaults.radius
        button.backgroundColor = .systemOrange
        return button
    }()
    private let leftImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = Constants.defaults.radius
        view.clipsToBounds = true
        return view
    }()
    private let leftTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.button.font
        label.textColor = .white
        return label
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.defaults.radius
        button.backgroundColor = .systemOrange
        return button
    }()
    
    private let rightImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = Constants.defaults.radius
        view.clipsToBounds = true
        return view
    }()
    private let rightTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.button.font
        label.textColor = .white
        return label
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = Constants.defaults.horizontal
        view.distribution = .fillEqually
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension IconDescriptionTableViewCell {
    // MARK: - SetUp

    func setUp() {
        setUpConstraints()
    }
    func setUpConstraints() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.top.equalToSuperview().offset(Constants.defaults.vertical)
            make.height.equalTo(Constants.defaults.blockHeight)
            make.bottom.equalToSuperview()
        }
        stackView.addArrangedSubview(leftButton)
        leftButton.snp.makeConstraints { make in
            make.width.equalTo((Constants.screenWidth - (Constants.defaults.horizontal * 2)) / 2)
        }
        leftButton.addSubview(leftImageView)
        leftImageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(Constants.defaults.vertical / 2)
            make.width.height.equalTo(Constants.defaults.blockHeight - Constants.defaults.vertical)
        }
        leftButton.addSubview(leftTitleLabel)
        leftTitleLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.centerY.equalToSuperview()
        }
        stackView.addArrangedSubview(rightButton)
        rightButton.snp.makeConstraints { make in
            make.width.equalTo((Constants.screenWidth - (Constants.defaults.horizontal * 2)) / 2)
        }
        rightButton.addSubview(rightImageView)
        rightImageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(Constants.defaults.vertical / 2)
            make.width.height.equalTo(Constants.defaults.blockHeight - Constants.defaults.vertical)
        }
        rightButton.addSubview(rightTitleLabel)
        rightTitleLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.centerY.equalToSuperview()
        }
    }
}

extension IconDescriptionTableViewCell {
    // MARK: - bind
    func bind(data:[ItemMenu], controller: UIViewController) {
        if data.count == 2 {
            leftImageView.image = data[0].image
            leftTitleLabel.text = data[0].title
            rightImageView.image = data[1].image
            rightTitleLabel.text = data[1].title
        }
        leftButton.addAction(UIAction(handler: { [weak self]_ in
            let vc = BasicController()
            controller.navigationController?.pushViewController(vc, animated: true)
        }), for: .primaryActionTriggered)
        rightButton.addAction(UIAction(handler: { [weak self]_ in
            let vc = BasicController()
            controller.navigationController?.pushViewController(vc, animated: true)
        }), for: .primaryActionTriggered)
    }
}
