//
//  SignInViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 1/18/24.
//

import UIKit

class SignInViewController: BasicController {
    // MARK: - Property
    private let viewModel: SignInViewModel
    
    // MARK: - Components
    private let logoImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemOrange
        view.contentMode = .scaleAspectFit
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension SignInViewController {
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}
private extension SignInViewController {
    // MARK: - SetUp
    func setUp() {
        setUpConstraints()
        setUpAddAction()
    }
    
    func setUpConstraints() {
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.screenHeight * 0.1)
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.screenWidth / 2)
            make.height.equalTo(Constants.screenHeight * 0.05)
        }
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(Constants.defaults.vertical * 2)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.height.equalTo(Constants.defaults.blockHeight)
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.height.equalTo(Constants.defaults.blockHeight)
        }
        
        view.addSubview(missMatchLabel)
        missMatchLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom)
            make.left.right.equalToSuperview().inset(Constants.defaults.vertical)
        }
        
        view.addSubview(autoLoginButton)
        autoLoginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(Constants.defaults.vertical * 2)
            make.left.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        
        view.addSubview(buttonsStackView)
        buttonsStackView.snp.makeConstraints { make in
            make.centerY.equalTo(autoLoginButton.snp.centerY)
            make.right.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        buttonsStackView.addArrangedSubview(passwordFindButton)
        buttonsStackView.addArrangedSubview(signUpButton)
        
        view.addSubview(signInButton)
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(autoLoginButton.snp.bottom).offset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.height.equalTo(Constants.defaults.blockHeight)
        }
    }
    func setUpAddAction() {
//        signInButton.button.addTarget(self, action: #selector(didTapSignInButton), for: .primaryActionTriggered)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .primaryActionTriggered)
//        autoLoginButton.addTarget(self, action: #selector(didTapAutoLoginButton), for: .primaryActionTriggered)
//        passwordFindButton.addTarget(self, action: #selector(didTapPasswordFindButton), for: .primaryActionTriggered)
    }
}

extension SignInViewController {
    // MARK: - Method
    
    @objc
    func didTapSignUpButton() {
        let vc = SignUpViewController(viewModel: SignUpViewModel())
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    @objc
//    func didTapAutoLoginButton() {
//        self.viewModel.isAutoLogin.value?.toggle()
//    }
//    
//    @objc
//    func didTapPasswordFindButton() {
//        let alert = UIAlertController(title: "비밀번호 재설정", message: "입력하신 이메일로 재설정 메일을 발송합니다.", preferredStyle: .alert)
//
//        let cancel = UIAlertAction(title: "취소", style: .cancel)
//        let yes = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
//            guard let email = alert.textFields?[0].text else { return }
//            guard let self = self else { return }
//            self.viewModel.passwordFind(email: email)
//        }
//        alert.addTextField()
//        alert.textFields?[0].placeholder = "example@example.com"
//        alert.addAction(yes)
//        alert.addAction(cancel)
//        present(alert, animated: true)
//    }
//    
//    @objc
//    func didTapSignInButton() {
//        
//        guard let email = emailTextField.textField.text else { return }
//        guard let password = passwordTextField.textField.text else { return }
//        IndicatorMaker.showLoading()
//        
//        viewModel.trySignIn(email: email, password: password, completion: { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .emptyEmail:
//                missMatchLabelShow(isShow: true, content: "이메일을 입력해 주세요.")
//            case .emptyPassword:
//                missMatchLabelShow(isShow: true, content: "패스워드를 입력해 주세요.")
//            case .fail:
//                missMatchLabelShow(isShow: true, content: "이메일 또는 비밀번호를 잘못 입력했습니다. 입력하신 내용을 다시 확인해주세요.")
//            case .success:
//                missMatchLabelShow(isShow: false, content: nil)
//                let rootView = MyCustomTabBarController()
//                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(viewController: rootView, animated: false)
//            }
//            IndicatorMaker.hideLoading()
//        })
//    }
//    
//    func missMatchLabelShow(isShow: Bool, content: String?) {
//        if isShow {
//            missMatchLabel.text = content
//            missMatchLabel.alpha = 1
//            missMatchLabel.shake()
//        } else {
//            missMatchLabel.alpha = 0
//        }
//    }
}
