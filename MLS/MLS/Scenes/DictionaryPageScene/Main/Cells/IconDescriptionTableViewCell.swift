//
//  IconDescriptionTableViewCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/31/24.
//

import UIKit


// setup 수정 준영

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
            make.leading.equalTo(leftImageView.snp.trailing)
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
            make.leading.equalTo(rightImageView.snp.trailing)
            make.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.centerY.equalToSuperview()
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
