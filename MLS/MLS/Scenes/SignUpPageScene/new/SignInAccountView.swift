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
    
    private let warriorButton = CustomButton(type: .default, text: "전사")
    
    private let archerButton = CustomButton(type: .default, text: "궁수")
    
    private let thiefButton = CustomButton(type: .default, text: "도적")
    
    private let mageButton = CustomButton(type: .default, text: "법사")

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
