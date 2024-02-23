//
//  SignInFirstViewController.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/22.
//

import UIKit

import SnapKit

class SignInFirstViewController: BasicController {
    // MARK: - Properties

    private let viewModel: SignInFirstViewModel
        
    // MARK: - Components
    
    private let firstPageImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "pagination_first")
        return view
    }()
    
    private let secondPageImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "pagination_second")
        return view
    }()

    private let emailTextField = CustomTextField(type: .normal, header: "이메일", placeHolder: "이메일을 입력해주세요")
    
    private let firstPwTextField = CustomTextField(type: .password, header: "비밀번호", placeHolder: "비밀번호를 입력해주세요", footer: "8자리 이상, 영어, 숫자, 특수문자")
    
    private let secondPwTextField = CustomTextField(type: .password, header: "비밀번호 재확인", placeHolder: "비밀번호를 다시 한 번 입력해주세요")
    
    lazy var privacyButton: UIButton = {
        let button = UIButton()
        button.setTitle("[필수] 개인정보 처리 방침 동의", for: .normal)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        button.configuration?.imagePlacement = .leading
        button.setTitleColor(.semanticColor.text.secondary, for: .normal)
        button.titleLabel?.font = .customFont(fontSize: .body_sm, fontType: .medium)
        button.tintColor = .semanticColor.bolder.primary
        return button
    }()
    
    private let showPrivacyButton: UIButton = {
        let button = UIButton()
        let attributeString = NSMutableAttributedString(string: "전체보기", attributes: [NSAttributedString.Key.font: UIFont.customFont(fontSize: .body_sm, fontType: .regular) as Any])
        attributeString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributeString.length))
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.semanticColor.text.secondary as Any, range: NSRange(location: 0, length: attributeString.length))
        button.setAttributedTitle(attributeString, for: .normal)
        return button
    }()
    
    private let nextButton = CustomButton(type: .disabled, text: "다음으로")
    
    init(viewModel: SignInFirstViewModel) {
        self.viewModel = viewModel
        super.init()
    }
        
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension SignInFirstViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
}

// MARK: - SetUp
private extension SignInFirstViewController {
    func setUp() {
        emailTextField.textField.delegate = self
        firstPwTextField.textField.delegate = self
        secondPwTextField.textField.delegate = self
        
        firstPwTextField.footerLabel.isHidden = false
        
        setUpConstraints()
        setUpNavigation()
        setUpActions()
    }
        
    func setUpConstraints() {
        view.addSubview(firstPageImageView)
        view.addSubview(secondPageImageView)
        view.addSubview(emailTextField)
        view.addSubview(firstPwTextField)
        view.addSubview(secondPwTextField)
        view.addSubview(privacyButton)
        view.addSubview(showPrivacyButton)
        view.addSubview(nextButton)
        
        firstPageImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(secondPageImageView.snp.leading).inset(-Constants.spacings.sm)
            $0.size.equalTo(24)
        }
        
        secondPageImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.size.equalTo(24)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(firstPageImageView.snp.bottom).offset(Constants.spacings.xl)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
        }
        
        firstPwTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(Constants.spacings.lg)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
        }
        
        secondPwTextField.snp.makeConstraints {
            $0.top.equalTo(firstPwTextField.snp.bottom).offset(Constants.spacings.lg)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
        }
        
        privacyButton.snp.makeConstraints {
            $0.top.equalTo(secondPwTextField.snp.bottom).offset(Constants.spacings.lg)
            $0.leading.equalToSuperview().inset(Constants.spacings.xl)
            $0.height.equalTo(22)
        }
        
        showPrivacyButton.snp.makeConstraints {
            $0.top.equalTo(secondPwTextField.snp.bottom).offset(Constants.spacings.lg)
            $0.leading.equalTo(privacyButton.snp.trailing).offset(Constants.spacings.sm + 5)
            $0.height.equalTo(22)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(privacyButton.snp.bottom).offset(111)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.height.equalTo(56)
        }
    }
    
    func setUpNavigation() {
        let spacer = UIBarButtonItem()
        let image = UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysTemplate)
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTapBackButton))
        let titleLabel = UILabel()
        titleLabel.text = "회원가입"
        titleLabel.font = .customFont(fontSize: .heading_sm, fontType: .semiBold)
        titleLabel.textColor = .themeColor(color: .base, value: .value_black)
        navigationItem.titleView = titleLabel
        
        backButton.tintColor = .themeColor(color: .base, value: .value_black)
        navigationItem.leftBarButtonItems = [spacer, backButton]
        navigationController?.navigationBar.isHidden = false
    }
    
    func setUpActions() {
        privacyButton.addAction(UIAction(handler: { [weak self] _ in
            self?.didTapPrivacyButton()
        }), for: .touchUpInside)
        
        showPrivacyButton.addAction(UIAction(handler: { [weak self] _ in
            self?.didTapShowPrivacyButton()
        }), for: .touchUpInside)
        
        nextButton.addAction(UIAction(handler: { [weak self] _ in
            self?.didTapNextButton()
        }), for: .touchUpInside)
    }
}

// MARK: - Bind
private extension SignInFirstViewController {
    func bind() {}
}

// MARK: - Method
extension SignInFirstViewController {
    func didTapPrivacyButton() {
        privacyButton.isSelected = !privacyButton.isSelected
        privacyButton.setImage(privacyButton.isSelected ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square"), for: .normal)
        privacyButton.tintColor = privacyButton.isSelected ? .semanticColor.bg.brand : .semanticColor.bolder.primary
    }
    
    func didTapShowPrivacyButton() {}
    
    func didTapNextButton() {
        let vc = SignInSecondViewController(viewModel: SignInSecondViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension SignInFirstViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 엔터
        if textField.text == "1" {
            nextButton.backgroundColor = textField.text == "1" ? .semanticColor.bg.interactive.primary : .semanticColor.bg.disabled
            nextButton.isUserInteractionEnabled = textField.text == "1"
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {}
    
    func textFieldDidBeginEditing(_ textField: UITextField) {}
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
