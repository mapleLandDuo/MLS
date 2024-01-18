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
        button.contentEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: Constants.defaults.horizontal)
        button.titleEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: -Constants.defaults.horizontal / 2)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = Typography.body3.font
        button.tintColor = .systemOrange
        return button
    }()
    
//    private let signInButton = SharedButton(title: "로그인")
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
}

extension UITextField {
    func addPadding() {
        // width값에 원하는 padding 값을 넣어줍니다.
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.defaults.horizontal, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
    }
}
