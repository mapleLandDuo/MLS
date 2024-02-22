//
//  CustomTextField.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/22.
//

import UIKit

import SnapKit

class CustomTextField: UIStackView {
    enum TextFieldType {
        case normal
        case password
    }
    
    enum TextState: String {
        case normal
        case emailCheck = "이메일을 다시 확인해주세요."
        case emailBlank = "이메일을 입력해주세요."
        case pwCheck = "비밀번호를 다시 확인해주세요."
        case pwBlank = "비밀번호를 입력해주세요."
        case pwNotCorrect = "비밀번호가 일치하지 않아요"
        case emailExist = "이미 가입된 이메일이에요."
        case nickNameNotCorrect = "닉네임을 2~8자로 지어주세요."
        case nickNameExist = "중복된 닉네임이에요."
    }
    
    // MARK: - Properties
    
    private let type: TextFieldType
    
    private let state: TextState = .normal

    // MARK: - Components
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .medium)
        label.textColor = .semanticColor.text.primary
        label.isHidden = true
        return label
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.semanticColor.bolder.interactive.secondary?.cgColor
        return view
    }()
    
    var textField: UITextField = {
        let view = UITextField()
        view.font = .customFont(fontSize: .body_md, fontType: .medium)
        view.textColor = .semanticColor.text.secondary
        view.autocapitalizationType = .none
        return view
    }()
    
    lazy var additionalButton: UIButton = {
        let button = UIButton()
        button.setImage(self.type == .password ? UIImage(systemName: "eye") : UIImage(systemName: "xmark.circle"), for: .normal)
        button.isHidden = true
        button.tintColor = .semanticColor.icon.secondary
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.changeShowButtonColor()
        }), for: .touchUpInside)
        return button
    }()
    
    lazy var footerLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .regular)
        label.textColor = .semanticColor.text.secondary
        label.text = "8자리 이상, 영어, 숫자, 특수문자"
        label.isHidden = true
        return label
    }()
    
    init(type: TextFieldType, header: String?, placeHolder: String) {
        self.type = type
        super.init(frame: .zero)
        if let header = header {
            headerLabel.isHidden = false
            headerLabel.text = header
        }
        textField.placeholder = placeHolder
        textField.isSecureTextEntry = type == .normal ? false : true
        setUp()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension CustomTextField {
    func setUp() {
        self.distribution = .fill
        self.spacing = Constants.spacings.xs
        self.axis = .vertical
        self.alignment = .fill
        
        addArrangedSubview(headerLabel)
        addArrangedSubview(contentView)
        contentView.addSubview(textField)
        contentView.addSubview(additionalButton)
        addArrangedSubview(footerLabel)
        
        headerLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xs_2)
            $0.height.equalTo(22)
        }
        
        contentView.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        textField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.spacings.lg)
            $0.leading.equalToSuperview().inset(Constants.spacings.sm)
            $0.height.equalTo(24)
        }
        
        additionalButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.spacings.lg)
            $0.leading.equalTo(textField.snp.trailing).offset(Constants.spacings.xs)
            $0.trailing.equalToSuperview().inset(Constants.spacings.sm)
            $0.width.equalTo(20)
        }
        
        footerLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xs_2)
            $0.height.equalTo(22)
        }
    }
}

// MARK: - Methods
extension CustomTextField {
    func checkAdditionalButton(isHidden: Bool) {
        additionalButton.isHidden = !isHidden
    }
    
    func checkState(state: TextState, isCorrect: Bool) {
        switch state {
        case .normal:
            footerLabel.isHidden = isCorrect
        default:
            setFooterLabel(isCorrect: isCorrect, state: state)
        }
    }

    private func setFooterLabel(isCorrect: Bool, state: TextState) {
        footerLabel.isHidden = isCorrect
        footerLabel.textColor = isCorrect ? UIColor.semanticColor.text.secondary : UIColor.semanticColor.text.distructive
        footerLabel.text = state.rawValue
        contentView.layer.borderColor = isCorrect ? UIColor.semanticColor.bolder.interactive.secondary?.cgColor : UIColor.semanticColor.bolder.distructive?.cgColor
    }
    
    private func changeShowButtonColor() {
        switch type {
        case .normal:
            textField.text = ""
        case .password:
            textField.isSecureTextEntry.toggle()
            if textField.isSecureTextEntry {
                UIView.animate(withDuration: 0.1) {
                    self.additionalButton.setImage(UIImage(systemName: "eye"), for: .normal)
                }
            } else {
                UIView.animate(withDuration: 0.1) {
                    self.additionalButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
                }
            }
        }
    }
}

