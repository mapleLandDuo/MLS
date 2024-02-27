//
//  CustomTextField.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/22.
//

import UIKit

import SnapKit

enum TextState: String {
    case `default`
    case complete
    case emailCheck = "이메일을 다시 확인해주세요."
    case emailBlank = "이메일을 입력해주세요."
    case pwCheck = "비밀번호를 다시 확인해주세요."
    case pwBlank = "비밀번호를 입력해주세요."
    case pwOutOfBounds
    case pwNotENG
    case pwNotInt
    case pwNotSymbol
    case pwNotCorrect = "비밀번호가 일치하지 않아요"
    case emailExist = "이미 가입된 이메일이에요."
    case nickNameExist = "중복된 닉네임이에요."
    case nickNameNotCorrect = "닉네임을 2~8자로 지어주세요"
    case lvNotInt = "숫자만 입력해주세요"
    case lvOutOfBounds = "1~200 사잇값만 넣어주세요"
}

enum TextFieldType {
    case normal
    case password
}

class CustomTextField: UIStackView {
    // MARK: - Properties
    
    private let type: TextFieldType
    
    var state: TextState = .default
    
    var attributedString = NSMutableAttributedString(string: "8자리 이상, 영어, 숫자, 특수문자")

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
    
    lazy var textField: UITextField = {
        let view = UITextField()
        view.font = .customFont(fontSize: .body_md, fontType: .medium)
        view.textColor = .semanticColor.text.secondary
        view.inputAccessoryView = nil
        view.autocapitalizationType = .none
        view.addAction(UIAction(handler: { [weak self] _ in
            guard let text = self?.textField.text else { return }
            self?.setAdditional(text: text)
        }), for: .editingChanged)
        return view
    }()
    
    lazy var additionalButton: UIButton = {
        let button = UIButton()
        button.setImage(self.type == .password ? UIImage(systemName: "eye") : UIImage(systemName: "xmark.circle"), for: .normal)
        button.isHidden = true
        button.tintColor = .semanticColor.icon.secondary
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.changeAdditionalButton()
        }), for: .touchUpInside)
        return button
    }()
    
    lazy var footerLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .regular)
        label.textColor = .semanticColor.text.secondary
        label.isHidden = true
        return label
    }()
    
    init(type: TextFieldType, header: String?, placeHolder: String, footer: String = "") {
        self.type = type
        super.init(frame: .zero)
        if let header = header {
            headerLabel.isHidden = false
            headerLabel.text = header
        }
        footerLabel.text = footer
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
        distribution = .fill
        spacing = Constants.spacings.xs
        axis = .vertical
        alignment = .fill
        
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
    func checkState(state: TextState, isCorrect: Bool) {
        self.state = state
        switch state {
        case .complete:
            footerLabel.isHidden = isCorrect
            contentView.layer.borderColor = UIColor.semanticColor.bolder.interactive.secondary?.cgColor
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
    
    private func changeAdditionalButton() {
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
    
    private func setAdditional(text: String) {
        additionalButton.isHidden = text == "" ? true : false
    }
    
//    func setPasswordFooter(isCorrect: Bool, state: TextState) {
//        footerLabel.isHidden = false
//
//        let fullText = "8자리 이상, 영어, 숫자, 특수문자"
//        let attribtuedString = NSMutableAttributedString(string: fullText)
//        var keyword = ""
//
//        switch state {
//        case .complete:
//            footerLabel.text = fullText
//            footerLabel.textColor = isCorrect ? .semanticColor.text.success_bold : .semanticColor.text.distructive_bold
//            if !isCorrect {
//                contentView.layer.borderColor = UIColor.semanticColor.bolder.distructive?.cgColor
//            }
//        case .pwNotENG:
//            keyword = "영어"
//            if isCorrect {
//                let range = (fullText as NSString).range(of: keyword)
//                attribtuedString.addAttribute(.foregroundColor, value: UIColor.semanticColor.text.success_bold, range: range)
//                footerLabel.textColor = UIColor.semanticColor.text.distructive
//                footerLabel.attributedText = attribtuedString
//            } else {
//                let range = (fullText as NSString).range(of: keyword)
//                attribtuedString.addAttribute(.foregroundColor, value: UIColor.semanticColor.text.distructive_bold, range: range)
//                footerLabel.textColor = UIColor.semanticColor.text.distructive
//                footerLabel.attributedText = attribtuedString
//            }
//        case .pwNotInt:
//            keyword = "숫자"
//            if isCorrect {
//                let range = (fullText as NSString).range(of: keyword)
//                attribtuedString.addAttribute(.foregroundColor, value: UIColor.semanticColor.text.success_bold, range: range)
//                footerLabel.textColor = UIColor.semanticColor.text.distructive
//                footerLabel.attributedText = attribtuedString
//            } else {
//                let range = (fullText as NSString).range(of: keyword)
//                attribtuedString.addAttribute(.foregroundColor, value: UIColor.semanticColor.text.distructive_bold, range: range)
//                footerLabel.textColor = UIColor.semanticColor.text.distructive
//                footerLabel.attributedText = attribtuedString
//            }
//        case .pwNotSpecial:
//            keyword = "특수문자"
//            if isCorrect {
//                let range = (fullText as NSString).range(of: keyword)
//                attribtuedString.addAttribute(.foregroundColor, value: UIColor.semanticColor.text.success_bold, range: range)
//                footerLabel.textColor = UIColor.semanticColor.text.distructive
//                footerLabel.attributedText = attribtuedString
//            } else {
//                let range = (fullText as NSString).range(of: keyword)
//                attribtuedString.addAttribute(.foregroundColor, value: UIColor.semanticColor.text.distructive_bold, range: range)
//                footerLabel.textColor = UIColor.semanticColor.text.distructive
//                footerLabel.attributedText = attribtuedString
//            }
//        case .pwOutOfBounds:
//            keyword = "8자리 이상"
//            if isCorrect {
//                let range = (fullText as NSString).range(of: keyword)
//                attribtuedString.addAttribute(.foregroundColor, value: UIColor.semanticColor.text.success_bold, range: range)
//                footerLabel.textColor = UIColor.semanticColor.text.distructive
//                footerLabel.attributedText = attribtuedString
//            } else {
//                let range = (fullText as NSString).range(of: keyword)
//                attribtuedString.addAttribute(.foregroundColor, value: UIColor.semanticColor.text.distructive_bold, range: range)
//                footerLabel.textColor = UIColor.semanticColor.text.distructive
//                footerLabel.attributedText = attribtuedString
//            }
//        default:
//            break
//        }
//    }
    
    func setPasswordFooter(checkPassword: [Bool], state: TextState) {
        footerLabel.isHidden = false

        let greenAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.semanticColor.text.success_bold]
        let redAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.semanticColor.text.distructive_bold]
        
        for i in 0...3 {
            switch i {
            case 0:
                guard let range = attributedString.string.range(of: "8자리 이상") else { return }
                if checkPassword[i] == true {
                    attributedString.addAttributes(greenAttributes, range: NSRange(range, in: attributedString.string))
                } else {
                    attributedString.addAttributes(redAttributes, range: NSRange(range, in: attributedString.string))
                }
            case 1:
                guard let range = attributedString.string.range(of: ", 특수문자") else { return }
                if checkPassword[i] == true {
                    attributedString.addAttributes(greenAttributes, range: NSRange(range, in: attributedString.string))
                } else {
                    attributedString.addAttributes(redAttributes, range: NSRange(range, in: attributedString.string))
                }
            case 2:
                guard let range = attributedString.string.range(of: ", 숫자") else { return }
                if checkPassword[i] == true {
                    attributedString.addAttributes(greenAttributes, range: NSRange(range, in: attributedString.string))
                } else {
                    attributedString.addAttributes(redAttributes, range: NSRange(range, in: attributedString.string))
                }
            case 3:
                guard let range = attributedString.string.range(of: ", 영어") else { return }
                if checkPassword[i] == true {
                    attributedString.addAttributes(greenAttributes, range: NSRange(range, in: attributedString.string))
                } else {
                    attributedString.addAttributes(redAttributes, range: NSRange(range, in: attributedString.string))
                }
            default:
                break
            }
        }
//        switch state {
//        case .complete:
//            footerLabel.text = "8자리 이상, 영어, 숫자, 특수문자"
//            footerLabel.textColor = isCorrect ? .semanticColor.text.success_bold : .semanticColor.text.distructive_bold
//            if !isCorrect {
//                contentView.layer.borderColor = UIColor.semanticColor.bolder.distructive?.cgColor
//            }
//            attributedString = NSMutableAttributedString(string: "8자리 이상, 영어, 숫자, 특수문자")
//        case .pwNotENG:
//            guard let range = attributedString.string.range(of: "영어") else { return }
//            if isCorrect {
//                attributedString.addAttributes(greenAttributes, range: NSRange(range, in: attributedString.string))
//            } else {
//                attributedString.addAttributes(redAttributes, range: NSRange(range, in: attributedString.string))
//            }
//        case .pwNotInt:
//            guard let range = attributedString.string.range(of: "숫자") else { return }
//            if isCorrect {
//                attributedString.addAttributes(greenAttributes, range: NSRange(range, in: attributedString.string))
//            } else {
//                attributedString.addAttributes(redAttributes, range: NSRange(range, in: attributedString.string))
//            }
//        case .pwNotSymbol:
//            guard let range = attributedString.string.range(of: "특수문자") else { return }
//            if isCorrect {
//                attributedString.addAttributes(greenAttributes, range: NSRange(range, in: attributedString.string))
//            } else {
//                attributedString.addAttributes(redAttributes, range: NSRange(range, in: attributedString.string))
//            }
//        case .pwOutOfBounds:
//            guard let range = attributedString.string.range(of: "8자리 이상") else { return }
//            if isCorrect {
//                attributedString.addAttributes(greenAttributes, range: NSRange(range, in: attributedString.string))
//            } else {
//                attributedString.addAttributes(redAttributes, range: NSRange(range, in: attributedString.string))
//            }
//        default:
//            break
//        }
        footerLabel.attributedText = attributedString
    }
}
