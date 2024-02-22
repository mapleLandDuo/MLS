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
        let view = UIStackView(arrangedSubviews: [warriorButton, archerButton, thiefButton, mageButton])
        view.spacing = Constants.spacings.md
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    private let warriorButton = CustomButton(text: "전사", textColor: .semanticColor.text.secondary, textFont: .customFont(fontSize: .body_md, fontType: .semiBold), backgroundColor: .themeColor(color: .base, value: .value_white) ,clickedColor: .jobBadgeColor.warrior, borderColor: .semanticColor.bolder.secondary)
    
    private let archerButton = CustomButton(text: "궁수", textColor: .semanticColor.text.secondary, textFont: .customFont(fontSize: .body_md, fontType: .semiBold), backgroundColor: .themeColor(color: .base, value: .value_white) , clickedColor: .jobBadgeColor.archer, borderColor: .semanticColor.bolder.secondary)
    
    private let thiefButton = CustomButton(text: "도적", textColor: .semanticColor.text.secondary, textFont: .customFont(fontSize: .body_md, fontType: .semiBold), backgroundColor: .themeColor(color: .base, value: .value_white) , clickedColor: .jobBadgeColor.thief, borderColor: .semanticColor.bolder.secondary)
    
    private let mageButton = CustomButton(text: "법사", textColor: .semanticColor.text.secondary, textFont: .customFont(fontSize: .body_md, fontType: .semiBold), backgroundColor: .themeColor(color: .base, value: .value_white) , clickedColor: .jobBadgeColor.mage, borderColor: .semanticColor.bolder.secondary)

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
