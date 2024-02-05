//
//  IconDescriptionTableViewCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/31/24.
//

import UIKit

import SnapKit

protocol IconDescriptionTableViewCellDelegate: AnyObject {
    func tapLeftButton(data: [ItemMenu])
    func tapRightButton(data: [ItemMenu])
}

class IconDescriptionTableViewCell: UITableViewCell {
    // MARK: Properties

    weak var delegate: IconDescriptionTableViewCellDelegate?

    var data: [ItemMenu]?

    // MARK: - Components

    lazy var leftButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.defaults.radius
        button.backgroundColor = .systemOrange
        button.addAction(UIAction(handler: { [weak self] _ in
            if let self = self, let data = self.data {
                self.delegate?.tapLeftButton(data: data)
            }
        }), for: .touchUpInside)
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
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.defaults.radius
        button.backgroundColor = .systemOrange
        button.addAction(UIAction(handler: { [weak self] _ in
            if let self = self, let data = self.data {
                self.delegate?.tapRightButton(data: data)
            }
        }), for: .touchUpInside)
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
        label.textAlignment = .center
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

    @available(*, unavailable)
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
        stackView.addArrangedSubview(leftButton)
        leftButton.addSubview(leftImageView)
        leftButton.addSubview(leftTitleLabel)
        stackView.addArrangedSubview(rightButton)
        rightButton.addSubview(rightImageView)
        rightButton.addSubview(rightTitleLabel)
        
        stackView.snp.makeConstraints { 
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.top.equalToSuperview().offset(Constants.defaults.vertical)
            $0.height.equalTo(Constants.defaults.blockHeight)
            $0.bottom.equalToSuperview()
        }

        leftButton.snp.makeConstraints { 
            $0.width.equalTo((Constants.screenWidth - (Constants.defaults.horizontal * 2)) / 2)
        }

        leftImageView.snp.makeConstraints { 
            $0.leading.top.equalToSuperview().inset(Constants.defaults.vertical / 2)
            $0.width.height.equalTo(Constants.defaults.blockHeight - Constants.defaults.vertical)
        }

        leftTitleLabel.snp.makeConstraints { 
            $0.leading.equalTo(leftImageView.snp.trailing)
            $0.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.centerY.equalToSuperview()
        }

        rightButton.snp.makeConstraints { 
            $0.width.equalTo((Constants.screenWidth - (Constants.defaults.horizontal * 2)) / 2)
        }

        rightImageView.snp.makeConstraints { 
            $0.leading.top.equalToSuperview().inset(Constants.defaults.vertical / 2)
            $0.width.height.equalTo(Constants.defaults.blockHeight - Constants.defaults.vertical)
        }

        rightTitleLabel.snp.makeConstraints { 
            $0.leading.equalTo(rightImageView.snp.trailing)
            $0.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.centerY.equalToSuperview()
        }
    }
}

// MARK: - bind
extension IconDescriptionTableViewCell {

    func bind(data: [ItemMenu]) {
        if data.count == 2 {
            self.data = data
            leftImageView.image = data[0].image
            leftTitleLabel.text = data[0].title.rawValue
            rightImageView.image = data[1].image
            rightTitleLabel.text = data[1].title.rawValue
        }
    }
}
