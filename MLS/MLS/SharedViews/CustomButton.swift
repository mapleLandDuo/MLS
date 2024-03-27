//
//  CustomButton.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/22.
//

import UIKit

import RxCocoa
import RxSwift

enum CustomButtonType {
    case `default`
    case clickabled
    case disabled
    case clicked
}

class CustomButton: UIButton {
    // MARK: Properties
    private var bgColor: UIColor?
    private var borderColor: UIColor?
    private var titleColor: UIColor?
    private var clickedBackgroundColor: UIColor?
    private var clickedBorderColor: UIColor?
    private var clickedTitleColor: UIColor?
    
    private let disposeBag = DisposeBag()
    var isClicked = BehaviorRelay<Bool>(value: false)
    var type = BehaviorRelay<CustomButtonType>(value: .default)
    
    init(type: CustomButtonType, text: String, borderColor: UIColor? = .semanticColor.bolder.secondary, radius: CGFloat = 12) {
        super.init(frame: .zero)
        self.bind(text: text, borderColor: borderColor, radius: radius)
        self.type.accept(type)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    func setButtonClicked(backgroundColor: UIColor?, borderColor: UIColor?, titleColor: UIColor?, clickedBackgroundColor: UIColor?, clickedBorderColor: UIColor?, clickedTitleColor: UIColor?) {
        self.bgColor = backgroundColor
        self.borderColor = borderColor
        self.titleColor = titleColor
        self.clickedBackgroundColor = clickedBackgroundColor
        self.clickedBorderColor = clickedBorderColor
        self.clickedTitleColor = clickedTitleColor
    }
    
    func bind(text: String, borderColor: UIColor?, radius: CGFloat) {
        type
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, type in
                owner.setTitle(text, for: .normal)
                owner.titleLabel?.textAlignment = .center
                owner.layer.cornerRadius = radius
                owner.layer.shadowColor = UIColor(red: 0.98, green: 0.58, blue: 0.239, alpha: 0.16).cgColor
                owner.layer.shadowOpacity = 1
                owner.layer.shadowRadius = 4
                owner.layer.shadowOffset = CGSize(width: 2, height: 2)
                switch type {
                case .default:
                    owner.setButtonDefault(borderColor: borderColor)
                case .clickabled:
                    owner.setButtonClickabled()
                case .disabled:
                    owner.setButtonDisabled()
                case .clicked:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        isClicked
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, isClicked in
                if isClicked == false {
                    owner.backgroundColor = owner.bgColor
                    owner.setTitleColor(owner.titleColor, for: .normal)
                    if let borderColor = owner.borderColor {
                        owner.layer.borderColor = borderColor.cgColor
                    }
                } else {
                    owner.backgroundColor = owner.clickedBackgroundColor
                    owner.setTitleColor(owner.clickedTitleColor, for: .normal)
                    if let clickedBorderColor = owner.clickedBorderColor {
                        owner.layer.borderColor = clickedBorderColor.cgColor
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
