//
//  SignUpViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 1/18/24.
//

import UIKit

class SignUpViewController: BasicController {
    // MARK: - Property
    private let viewModel: SignUpViewModel
    
    // MARK: - Components

    private let signUpTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title1.font
        label.text = "회원가입"
        return label
    }()
    private let emailTextField = SharedTextField(type: .title, placeHolder: "이메일을 입력해주세요.", title: "이메일")
    private let nickNameTextField = SharedTextField(type: .title, placeHolder: "닉네임을 입력해주세요.", title: "닉네임")
    private let passwordTextField = SharedTextField(type: .titlePassword, placeHolder: "비밀번호를 입력해주세요.", title: "비밀번호")
    private let checkPasswordTextField = SharedTextField(type: .titlePassword, placeHolder: "동일한 비밀번호를 입력해주세요.", title: "비밀번호 확인")
    private let privacyAgreeButton: UIButton = {
        let button = UIButton()
        button.setTitle("개인정보 처리방침에 동의합니다.", for: .normal)
        button.titleLabel?.font = Typography.body2.font
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.tintColor = .systemOrange
        return button
    }()
    
    private let privacyShowButton: UIButton = {
        let button = UIButton()
        button.setTitle("[보기]", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = Typography.body2.font
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.titleLabel?.font = Typography.button.font
        button.layer.cornerRadius = Constants.defaults.radius
        return button
    }()
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension SignUpViewController {
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}
private extension SignUpViewController {
    // MARK: - SetUp

    func setUp() {
        setUpConstraints()
    }
    
    func setUpConstraints() {
        view.addSubview(signUpTitleLabel)
        signUpTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(Constants.defaults.vertical)
            make.left.equalTo(view.safeAreaLayoutGuide).inset(Constants.defaults.horizontal)
        }
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(signUpTitleLabel.snp.bottom).offset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        
        view.addSubview(nickNameTextField)
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        
        view.addSubview(checkPasswordTextField)
        checkPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        
        view.addSubview(privacyAgreeButton)
        privacyAgreeButton.snp.makeConstraints { make in
            make.top.equalTo(checkPasswordTextField.snp.bottom).offset(Constants.defaults.vertical)
            make.left.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        
        view.addSubview(privacyShowButton)
        privacyShowButton.snp.makeConstraints { make in
            make.centerY.equalTo(privacyAgreeButton.snp.centerY)
            make.left.equalTo(privacyAgreeButton.snp.right).offset(Constants.defaults.horizontal)
        }
        
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(Constants.defaults.horizontal)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.defaults.vertical)
            make.height.equalTo(Constants.defaults.blockHeight)
        }
    }
}
