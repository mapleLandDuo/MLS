//
//  MyPageSecessionViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 3/1/24.
//

import UIKit

import SnapKit

protocol MyPageBottomViewControllerDelegate: BasicController {
    func didTapApplyButton(type: MyPageBottomControllerTypeEnum)
}

enum MyPageBottomControllerTypeEnum {
    case logout
    case secession
}

class MyPageBottomViewController: BasicController {
    // MARK: - Properties
    
    private var type: MyPageBottomControllerTypeEnum
    
    weak var delegate: MyPageBottomViewControllerDelegate?

    // MARK: - Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "정말 탈퇴를 진행하시겠어요?"
        label.textColor = .semanticColor.text.primary
        label.font = .customFont(fontSize: .body_md, fontType: .semiBold)
        label.addCharacterSpacing()
        return label
    }()
    
    private let warningStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = Constants.spacings.xs
        return view
    }()
    
    private let warningImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "alert-triangle")
        return view
    }()
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = "다시 복구할 수 없습니다."
        label.font = .customFont(fontSize: .body_sm, fontType: .medium)
        label.textColor = .semanticColor.text.distructive
        label.addCharacterSpacing()
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = Constants.spacings.sm
        view.distribution = .fillEqually
        return view
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.semanticColor.bolder.secondary?.cgColor
        button.titleLabel?.font = .customFont(fontSize: .body_md, fontType: .semiBold)
        button.titleLabel?.addCharacterSpacing()
        button.setTitleColor(.semanticColor.text.secondary, for: .normal)
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.16).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 4
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.backgroundColor = .themeColor(color: .base, value: .value_white)
        return button
    }()
    
    private let applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("탈퇴하기", for: .normal)
        button.backgroundColor = .semanticColor.bg.interactive.secondary
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .customFont(fontSize: .body_md, fontType: .semiBold)
        button.titleLabel?.addCharacterSpacing()
        button.setTitleColor(.themeColor(color: .base, value: .value_white), for: .normal)
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.16).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 4
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        return button
    }()
    
    init(type: MyPageBottomControllerTypeEnum) {
        self.type = type
        switch type {
        case .logout:
            titleLabel.text = "로그아웃 하시겠어요?"
            applyButton.setTitle("로그아웃", for: .normal)
            warningLabel.isHidden = true
            warningImage.isHidden = true
        case .secession:
            print(#function)
        }
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - LifeCycle
extension MyPageBottomViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

// MARK: - SetUp
extension MyPageBottomViewController {
    func setUp() {
        setUpConstraints()
        setUpAddAction()
    }
    
    func setUpAddAction() {
        cancelButton.addAction(UIAction(handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }), for: .primaryActionTriggered)
        
        applyButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            guard let email = LoginManager.manager.email else { return }
            switch self.type {
            case .secession:
                IndicatorManager.showIndicator(vc: self)
                FirebaseManager.firebaseManager.deleteUserData(email: email) {
                    LoginManager.manager.deleteUser {
                        IndicatorManager.hideIndicator(vc: self)
                        self.dismiss(animated: true, completion: {
                            self.delegate?.didTapApplyButton(type: self.type)
                        })
                    }
                }
            case .logout:
                IndicatorManager.showIndicator(vc: self)
                LoginManager.manager.logOut { isLogOut in
                    IndicatorManager.hideIndicator(vc: self)
                    self.dismiss(animated: true) {
                        self.delegate?.didTapApplyButton(type: self.type)
                    }
                }
            }
        }), for: .primaryActionTriggered)
    }
    
    func setUpConstraints() {
        view.addSubview(titleLabel)
        warningStackView.addArrangedSubview(warningImage)
        warningStackView.addArrangedSubview(warningLabel)
        view.addSubview(warningStackView)
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(applyButton)
        view.addSubview(buttonStackView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.height.equalTo(24)
            $0.centerX.equalToSuperview()
        }
        
        warningImage.snp.makeConstraints {
            $0.size.equalTo(Constants.spacings.lg)
        }
        
        warningStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Constants.spacings.xl)
        }
    }
}
