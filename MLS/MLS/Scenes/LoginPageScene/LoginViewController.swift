//
//  LoginViewController.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/22.
//

import UIKit

import SnapKit

class LoginViewController: BasicController {
    // MARK: - Properties
    private let viewModel: LoginViewModel
    
    // MARK: - Components
    private let logoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "logo")
        return view
    }()
        
    private let emailTextField = CustomTextField(type: .normal, header: nil, placeHolder: "이메일 입력해주세요")
        
    private let pwTextField = CustomTextField(type: .password, header: nil, placeHolder: "비밀번호를 입력해주세요")

    lazy var autoLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("자동 로그인", for: .normal)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        var config = UIButton.Configuration.plain()
        config.imagePadding = 5
        config.imagePlacement = .leading
        button.configuration = config
        button.setTitleColor(.semanticColor.text.secondary, for: .normal)
        button.titleLabel?.font = .customFont(fontSize: .body_sm, fontType: .medium)
        button.tintColor = .semanticColor.bolder.primary
        return button
    }()
    
    private let pwFindButton: UIButton = {
        let button = UIButton()
        let attributeString = NSMutableAttributedString(string: "비밀번호 변경하기", attributes: [NSAttributedString.Key.font: UIFont.customFont(fontSize: .body_sm, fontType: .regular) as Any])
        attributeString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributeString.length))
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.semanticColor.text.secondary as Any, range: NSRange(location: 0, length: attributeString.length))
        button.setAttributedTitle(attributeString, for: .normal)
        return button
    }()
    
    private let logInButton = CustomButton(type: .disabled, text: "로그인")
    
    private let signUpButton = CustomButton(type: .default, text: "회원가입")
    
    private let descriptionTailImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "description_tail")
        return view
    }()
    
    private let descriptionMainImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "logInDescription_main")
        return view
    }()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init()
    }
        
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension LoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
}

// MARK: - SetUp
private extension LoginViewController {
    func setUp() {
        emailTextField.textField.delegate = self
        pwTextField.textField.delegate = self
        
        setUpConstraints()
        setUpNavigation()
        setUpActions()
    }
        
    func setUpConstraints() {
        view.addSubview(logoImageView)
        view.addSubview(emailTextField)
        view.addSubview(pwTextField)
        view.addSubview(autoLoginButton)
        view.addSubview(pwFindButton)
        view.addSubview(logInButton)
        view.addSubview(signUpButton)
        view.addSubview(descriptionTailImageView)
        view.addSubview(descriptionMainImageView)
            
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(Constants.spacings.lg)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(80)
        }
            
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(Constants.spacings.xl_4)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
        }
            
        pwTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(Constants.spacings.lg)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
        }
            
        autoLoginButton.snp.makeConstraints {
            $0.top.equalTo(pwTextField.snp.bottom).offset(Constants.spacings.sm)
            $0.leading.equalTo(emailTextField)
            $0.height.equalTo(22)
        }
        
        pwFindButton.snp.makeConstraints {
            $0.top.equalTo(pwTextField.snp.bottom).offset(Constants.spacings.sm)
            $0.trailing.equalTo(emailTextField)
            $0.height.equalTo(22)
        }

        logInButton.snp.makeConstraints {
            $0.top.equalTo(autoLoginButton.snp.bottom).offset(139)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.height.equalTo(56)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(logInButton.snp.bottom).offset(Constants.spacings.md)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.height.equalTo(56)
        }
        
        descriptionTailImageView.snp.makeConstraints {
            $0.top.equalTo(signUpButton.snp.bottom).offset(Constants.spacings.lg)
            $0.leading.equalTo(descriptionMainImageView).inset(Constants.spacings.xl)
            $0.size.equalTo(12)
        }
        
        descriptionMainImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionTailImageView.snp.bottom)
            $0.leading.equalToSuperview().inset(Constants.spacings.xl)
            $0.trailing.equalToSuperview().inset(87)
            $0.height.equalTo(44)
        }
    }
    
    func setUpNavigation() {
        let spacer = UIBarButtonItem()
        let image = UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysTemplate)
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTapBackButton))
        let titleLabel = UILabel()
        titleLabel.text = "로그인"
        titleLabel.font = .customFont(fontSize: .heading_sm, fontType: .semiBold)
        titleLabel.textColor = .themeColor(color: .base, value: .value_black)
        navigationItem.titleView = titleLabel
        
        backButton.tintColor = .themeColor(color: .base, value: .value_black)
        navigationItem.leftBarButtonItems = [spacer, backButton]
        navigationController?.navigationBar.isHidden = false
    }
    
    func setUpActions() {
        autoLoginButton.addAction(UIAction(handler: { [weak self] _ in
            self?.didTapAutoLoginButton()
        }), for: .touchUpInside)
        
        pwFindButton.addAction(UIAction(handler: { [weak self] _ in
            self?.didTapPwFindButton()
        }), for: .touchUpInside)
        
        logInButton.addAction(UIAction(handler: { [weak self] _ in
            self?.didTapLogInButton()
        }), for: .touchUpInside)
        
        signUpButton.addAction(UIAction(handler: { [weak self] _ in
            self?.didTapSignUpButton()
        }), for: .touchUpInside)
    }
}

// MARK: - Bind
private extension LoginViewController {
    func bind() {
        viewModel.isAutoLogin.bind { [weak self] state in
            guard let state = state else { return }
            self?.viewModel.userDefaultManager.setAutoLogin(toggle: state)
            if state {
                self?.autoLoginButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
                self?.autoLoginButton.tintColor = .semanticColor.bg.brand
            } else {
                self?.autoLoginButton.setImage(UIImage(systemName: "square"), for: .normal)
                self?.autoLoginButton.tintColor = .semanticColor.bolder.primary
            }
        }
    }
}

// MARK: - Method
private extension LoginViewController {
    func didTapAutoLoginButton() {
        viewModel.isAutoLogin.value?.toggle()
    }
        
    func didTapPwFindButton() {
        let vc = FindPasswordViewController(viewModel: FindPasswordViewModel())
        vc.preVC = self
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        present(vc, animated: true)
    }
        
    func didTapLogInButton() {
        guard let email = emailTextField.textField.text, let password = pwTextField.textField.text else { return }
        IndicatorManager.showIndicator(vc: self)
        viewModel.trySignIn(email: email, password: password) { [weak self] emailState, passwordState in
            guard let self = self else { return }
            IndicatorManager.hideIndicator(vc: self)
            let isEmailCorrect = (emailState == .complete || emailState == .default)
            let isPasswordCorrect = (passwordState == .complete || passwordState == .default)

            self.emailTextField.checkState(state: emailState, isCorrect: isEmailCorrect)
            self.pwTextField.checkState(state: passwordState, isCorrect: isPasswordCorrect)
            if emailState == .complete, passwordState == .complete {
                AlertMaker.showAlertAction1(vc: self, title: "로그인 성공", message: "확인 버튼을 누르면 메인 화면으로 돌아갑니다.") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func didTapSignUpButton() {
        let vc = SignUpFirstViewController(viewModel: SignUpFirstViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 엔터
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.superview?.layer.borderColor = UIColor.semanticColor.bolder.interactive.primary_pressed?.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.superview?.layer.borderColor = UIColor.semanticColor.bolder.interactive.secondary?.cgColor
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        logInButton.backgroundColor = !text.isEmpty ? .semanticColor.bg.interactive.primary : .semanticColor.bg.disabled
        logInButton.isUserInteractionEnabled = !text.isEmpty
    }
}

extension LoginViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting, size: 210)
    }
}
