//
//  AlertView.swift
//  MLS
//
//  Created by SeoJunYoung on 3/3/24.
//

import UIKit

import SnapKit

class AlertView: UIView {
    
    // MARK: - Components

    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var contentStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        view.axis = .vertical
        view.spacing = Constants.spacings.xs_2
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.addCharacterSpacing()
        label.font = .customFont(fontSize: .body_sm, fontType: .semiBold)
        label.textColor = .semanticColor.text.primary
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.addCharacterSpacing()
        label.font = .customFont(fontSize: .body_sm, fontType: .regular)
        label.textColor = .semanticColor.text.primary
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    init(type: AlertTypeEnum, title: String?, description: String?) {
        super.init(frame: .zero)
        print(self, "init")
        if let title {
            titleLabel.text = title
        } else {
            titleLabel.isHidden = true
        }
        if let description {
            descriptionLabel.text = description
        } else {
            descriptionLabel.isHidden = true
        }
        setUp()
        
        switch type {
        case .green:
            self.backgroundColor = .semanticColor.bg.success
            self.layer.borderColor = UIColor.semanticColor.bolder.success_bold?.cgColor
            self.iconImageView.image = UIImage(named: "check-circle")
            self.closeButton.tintColor = .semanticColor.icon.success
        case .red:
            self.backgroundColor = .semanticColor.bg.distructive
            self.layer.borderColor = UIColor.semanticColor.bolder.distructive?.cgColor
            self.iconImageView.image = UIImage(named: "alert-triangle")
            self.closeButton.tintColor = .semanticColor.icon.distructive
        case .blue:
            self.backgroundColor = .semanticColor.bg.info
            self.layer.borderColor = UIColor.semanticColor.bolder.info_bold?.cgColor
            self.iconImageView.image = UIImage(named: "info-blue")
            self.closeButton.tintColor = .semanticColor.icon.info
        case .yellow:
            self.backgroundColor = .semanticColor.bg.warning
            self.layer.borderColor = UIColor.semanticColor.bolder.warning_bold?.cgColor
            self.iconImageView.image = UIImage(named: "info-yellow")
            self.closeButton.tintColor = .semanticColor.icon.warning
        case .gray:
            self.backgroundColor = .semanticColor.bg.primary
            self.layer.borderColor = UIColor.semanticColor.bolder.tertiary?.cgColor
            self.iconImageView.image = UIImage(named: "info-gray")
            self.closeButton.tintColor = .semanticColor.icon.secondary
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(self, "deinit")
    }
    
}

// MARK: - SetUp
private extension AlertView {
    
    func setUp() {
        setUpConstraints()
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 12
        closeButton.addAction(UIAction(handler: { [weak self] _ in
            self?.removeFromSuperview()
        }), for: .primaryActionTriggered)
    }
    
    func setUpConstraints() {
        self.addSubview(iconImageView)
        self.addSubview(contentStackView)
//        self.addSubview(titleLabel)
//        self.addSubview(descriptionLabel)
        self.addSubview(closeButton)
        
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(Constants.spacings.xl)
            $0.leading.equalToSuperview().inset(Constants.spacings.lg)
            $0.centerY.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.size.equalTo(Constants.spacings.xl)
            $0.trailing.equalToSuperview().inset(Constants.spacings.lg)
            $0.centerY.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.spacings.sm)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(Constants.spacings.sm)
            $0.trailing.equalTo(closeButton.snp.leading).inset(-Constants.spacings.sm)
        }
        
        titleLabel.snp.makeConstraints {
//            $0.leading.equalTo(iconImageView.snp.trailing).offset(Constants.spacings.sm)
//            $0.trailing.equalTo(closeButton.snp.leading).inset(-Constants.spacings.sm)
//            $0.top.equalToSuperview().inset(Constants.spacings.sm)
            $0.height.equalTo(22)
        }
        
        descriptionLabel.snp.makeConstraints {
//            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.spacings.xs_2)
//            $0.trailing.equalTo(closeButton.snp.leading).inset(-Constants.spacings.sm)
//            $0.leading.equalTo(titleLabel.snp.leading)
//            $0.bottom.equalToSuperview().inset(Constants.spacings.sm)
            $0.height.equalTo(22)
        }
    }
}
