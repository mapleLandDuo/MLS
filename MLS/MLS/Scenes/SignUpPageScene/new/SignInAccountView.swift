//
//  SignInAccountView.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/23.
//

import UIKit

import SnapKit

class SignInAccountView: UIView {
    // MARK: - Components

    lazy var levelTextField = CustomTextField(type: .normal, header: "레벨을 입력해주세요", placeHolder: "ex) 30", footer: "숫자 1~200 사이의 값만 넣어주세요")

    private let rollLabel: UILabel = {
        let label = UILabel()
        label.text = "직업 선택"
        label.font = .customFont(fontSize: .body_sm, fontType: .medium)
        label.textColor = .semanticColor.text.primary
        return label
    }()

    lazy var rollButtonStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: buttons)
        view.spacing = Constants.spacings.md
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()

    lazy var buttons: [CustomButton] = [
        makeButton(text: "전사", color: .jobBadgeColor.warrior),
        makeButton(text: "궁수", color: .jobBadgeColor.archer),
        makeButton(text: "도적", color: .jobBadgeColor.thief),
        makeButton(text: "법사", color: .jobBadgeColor.mage)
    ]

    private func makeButton(text: String, color: UIColor?) -> CustomButton {
        let button = CustomButton(type: .default, text: text)
        button.setButtonClicked(backgroundColor: .themeColor(color: .base, value: .value_white), borderColor: .semanticColor.bolder.secondary, titleColor: .semanticColor.text.secondary, clickedBackgroundColor: color, clickedBorderColor: .semanticColor.text.primary, clickedTitleColor: .semanticColor.text.primary)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.buttons.forEach { $0.isClicked.value = $0 == button }
        }), for: .touchUpInside)
        return button
    }

    init() {
        super.init(frame: .zero)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension SignInAccountView {
    func setUp() {
        setUpConstraints()
    }

    func setUpConstraints() {
        addSubview(levelTextField)
        addSubview(rollLabel)
        addSubview(rollButtonStackView)

        levelTextField.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        rollLabel.snp.makeConstraints {
            $0.top.equalTo(levelTextField.snp.bottom).offset(Constants.spacings.lg)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(22)
        }

        rollButtonStackView.snp.makeConstraints {
            $0.top.equalTo(rollLabel.snp.bottom).offset(Constants.spacings.xs)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(48)
        }
    }
}
