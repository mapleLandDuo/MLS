//
//  CustomButton.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/22.
//

import UIKit

enum CustomButtonType {
    case `default`
    case clickabled
    case disabled
    case clicked
}

class CustomButton: UIButton {
    // MARK: Properties
    private var isClicked = false
    
    var type: Observable<CustomButtonType> = Observable(.default)
    
    init(type: CustomButtonType, text: String, borderColor: UIColor? = .semanticColor.bolder.secondary, radius: CGFloat = 12) {
        super.init(frame: .zero)
//        self.setUp(type: type, text: text, borderColor: borderColor, radius: radius)
        self.bind(text: text, borderColor: borderColor, radius: radius)
        self.type.value = type
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    private func setUp(type: ButtonType, text: String, borderColor: UIColor?, radius: CGFloat) {
//        self.setTitle(text, for: .normal)
//        self.titleLabel?.textAlignment = .center
//        self.layer.cornerRadius = radius
//        self.layer.shadowColor = UIColor(red: 0.98, green: 0.58, blue: 0.239, alpha: 0.16).cgColor
//        self.layer.shadowOpacity = 1
//        self.layer.shadowRadius = 4
//        self.layer.shadowOffset = CGSize(width: 2, height: 2)
//        switch type {
//        case .default:
//            self.setButtonDefault(borderColor: borderColor)
//        case .clickabled:
//            self.setButtonClickabled()
//        case .disabled:
//            self.setButtonDisabled()
//        case .clicked:
//            break
//        }
//    }
    
    private func setButtonDefault(borderColor: UIColor?) {
        self.isUserInteractionEnabled = true
        self.backgroundColor = .themeColor(color: .base, value: .value_white)
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor?.cgColor
        self.setTitleColor(.semanticColor.text.secondary, for: .normal)
        self.titleLabel?.font = .customFont(fontSize: .body_md, fontType: .semiBold)
    }
    
    private func setButtonClickabled() {
        self.isUserInteractionEnabled = true
        self.backgroundColor = .semanticColor.bg.interactive.primary
        self.setTitleColor(.themeColor(color: .base, value: .value_white), for: .normal)
        self.titleLabel?.font = .customFont(fontSize: .body_md, fontType: .semiBold)
    }
    
    private func setButtonDisabled() {
        self.isUserInteractionEnabled = false
        self.backgroundColor = .semanticColor.bg.disabled
        self.setTitleColor(.semanticColor.text.interactive.secondary, for: .normal)
        self.titleLabel?.font = .customFont(fontSize: .body_md, fontType: .semiBold)
    }
    
    func setButtonClicked(backgroundColor: UIColor, borderColor: UIColor?, titleColor: UIColor, clickedBackgroundColor: UIColor, clickedBorderColor: UIColor?, clickedTitleColor: UIColor) {
        self.layer.borderWidth = 1
        if self.isClicked == true {
            self.backgroundColor = backgroundColor
            self.setTitleColor(titleColor, for: .normal)
            if let borderColor = borderColor {
                self.layer.borderColor = borderColor.cgColor
            }
        } else {
            self.backgroundColor = clickedBackgroundColor
            self.setTitleColor(clickedTitleColor, for: .normal)
            if let clickedBorderColor = clickedBorderColor {
                self.layer.borderColor = clickedBorderColor.cgColor
            }
        }
        self.isClicked.toggle()
    }
    
    func bind(text: String, borderColor: UIColor?, radius: CGFloat) {
        type.bind { [weak self] _ in
            self?.setTitle(text, for: .normal)
            self?.titleLabel?.textAlignment = .center
            self?.layer.cornerRadius = radius
            self?.layer.shadowColor = UIColor(red: 0.98, green: 0.58, blue: 0.239, alpha: 0.16).cgColor
            self?.layer.shadowOpacity = 1
            self?.layer.shadowRadius = 4
            self?.layer.shadowOffset = CGSize(width: 2, height: 2)
            switch self?.type.value {
            case .default:
                self?.setButtonDefault(borderColor: borderColor)
            case .clickabled:
                self?.setButtonClickabled()
            case .disabled:
                self?.setButtonDisabled()
            case .clicked:
                break
            case .none:
                break
            }
        }
    }
}
