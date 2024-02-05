//
//  SignInViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 1/18/24.
//

import UIKit

import SnapKit

class SignInViewController: BasicController {
    // MARK: - Properties

    private let viewModel: SignInViewModel
    
    // MARK: - Components

    private let logoImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemOrange
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "AppLogo")
        return view
    }()
    
    private let emailTextField = SharedTextField(type: .normal, placeHolder: "이메일")
    
    private let passwordTextField = SharedTextField(type: .password, placeHolder: "패스워드")

    private let missMatchLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.body3.font
        label.textColor = .systemRed
        label.numberOfLines = 0
        label.alpha = 1
        return label
    }()

    private let autoLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("자동 로그인", for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        button.configuration?.imagePlacement = .leading
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = Typography.body3.font
        button.tintColor = .systemOrange
        return button
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.titleLabel?.font = Typography.button.font
        button.layer.cornerRadius = Constants.defaults.radius
        return button
    }()
    
    private let buttonsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .trailing
        view.spacing = Constants.defaults.horizontal
        view.distribution = .fill
        return view
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.titleLabel?.font = Typography.body3.font
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let passwordFindButton: UIButton = {
        let button = UIButton()
        button.setTitle("비밀번호 재설정", for: .normal)
        button.titleLabel?.font = Typography.body3.font
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension SignInViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
}

// MARK: - SetUp
private extension SignInViewController {

    func setUp() {
        setUpConstraints()
        setUpAddAction()
    }
    
    func setUpConstraints() {
        
        view.addSubview(logoImageView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(missMatchLabel)
        view.addSubview(autoLoginButton)
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(passwordFindButton)
        buttonsStackView.addArrangedSubview(signUpButton)
        view.addSubview(signInButton)
        
        logoImageView.snp.makeConstraints { 
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.screenHeight * 0.1)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(Constants.screenWidth * 0.7)
            $0.height.equalTo(Constants.screenHeight * 0.05)
        }
        

        emailTextField.snp.makeConstraints { 
            $0.top.equalTo(logoImageView.snp.bottom).offset(Constants.defaults.vertical * 2)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.height.equalTo(Constants.defaults.blockHeight)
        }
        

        passwordTextField.snp.makeConstraints { 
            $0.top.equalTo(emailTextField.snp.bottom).offset(Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.height.equalTo(Constants.defaults.blockHeight)
        }
        

        missMatchLabel.snp.makeConstraints { 
            $0.top.equalTo(passwordTextField.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        

        autoLoginButton.snp.makeConstraints { 
            $0.top.equalTo(passwordTextField.snp.bottom).offset(Constants.defaults.vertical * 3)
            $0.leading.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        

        buttonsStackView.snp.makeConstraints { 
            $0.centerY.equalTo(autoLoginButton.snp.centerY)
            $0.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }

        signInButton.snp.makeConstraints { 
            $0.top.equalTo(autoLoginButton.snp.bottom).offset(Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.height.equalTo(Constants.defaults.blockHeight)
        }
    }

    func setUpAddAction() {
        signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .primaryActionTriggered)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .primaryActionTriggered)
        autoLoginButton.addTarget(self, action: #selector(didTapAutoLoginButton), for: .primaryActionTriggered)
        passwordFindButton.addTarget(self, action: #selector(didTapPasswordFindButton), for: .primaryActionTriggered)
    }
}

// MARK: - Bind
private extension SignInViewController {

    func bind() {
        viewModel.isAutoLogin.bind { [weak self] state in
            guard let state = state else { return }
            self?.viewModel.userDefaultManager.setAutoLogin(toggle: state)
            if state {
                self?.autoLoginButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            } else {
                self?.autoLoginButton.setImage(UIImage(systemName: "square"), for: .normal)
            }
        }
    }
}

// MARK: - Method
extension SignInViewController {
    
    @objc
    func didTapSignUpButton() {
        let vc = SignUpViewController(viewModel: SignUpViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func didTapAutoLoginButton() {
        viewModel.isAutoLogin.value?.toggle()
    }
    
    @objc
    func didTapPasswordFindButton() {
        let alert = UIAlertController(title: "비밀번호 재설정", message: "입력하신 이메일로 재설정 메일을 발송합니다.", preferredStyle: .alert)

        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let yes = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let email = alert.textFields?[0].text else { return }
            guard let self = self else { return }
            self.viewModel.passwordFind(email: email)
        }
        alert.addTextField()
        alert.textFields?[0].placeholder = "example@example.com"
        alert.addAction(yes)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    @objc
    func didTapSignInButton() {
        guard let email = emailTextField.textField.text else { return }
        guard let password = passwordTextField.textField.text else { return }
        IndicatorMaker.showLoading()
        
        viewModel.trySignIn(email: email, password: password, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .emptyEmail:
                missMatchLabelShow(isShow: true, content: "이메일을 입력해 주세요.")
            case .emptyPassword:
                missMatchLabelShow(isShow: true, content: "패스워드를 입력해 주세요.")
            case .fail:
                missMatchLabelShow(isShow: true, content: "이메일 또는 비밀번호를 잘못 입력했습니다. 입력하신 내용을 다시 확인해주세요.")
            case .success:
                missMatchLabelShow(isShow: false, content: nil)
                AlertMaker.showAlertAction1(vc: self, title: "로그인 성공", message: "확인 버튼을 누르면 메인 화면으로 돌아갑니다.") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            IndicatorMaker.hideLoading()
        })
    }
    
    func missMatchLabelShow(isShow: Bool, content: String?) {
        if isShow {
            missMatchLabel.text = content
            missMatchLabel.alpha = 1
        } else {
            missMatchLabel.alpha = 0
        }
    }
}
