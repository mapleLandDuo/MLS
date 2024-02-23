//
//  SignInSecondViewController.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/22.
//

import UIKit

import SnapKit

class SignInSecondViewController: BasicController {
    // MARK: - Properties

    private let viewModel: SignInSecondViewModel
        
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

    private let nickNameTextField = CustomTextField(type: .normal, header: "사용할 닉네임을 입력해주세요", placeHolder: "닉네임을 입력하세요", footer: "글자수 2~8글자로 닉네임을 지어주세요")
    
    private let accountDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "메이플랜드 계정이 있으신가요?"
        label.font = .customFont(fontSize: .body_sm, fontType: .medium)
        label.textColor = .semanticColor.text.primary
        return label
    }()
    
    lazy var buttonStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [noneAccountButton, accountButton])
        view.axis = .horizontal
        view.spacing = Constants.spacings.md
        view.distribution = .fillEqually
        return view
    }()
    
    private let noneAccountButton: CustomButton = {
        let button = CustomButton(type: .clickabled, text: "아니요")
        button.backgroundColor = .semanticColor.bg.interactive.secondary
        button.setTitleColor(.themeColor(color: .base, value: .value_white), for: .normal)
        return button
    }()
    
    private let accountButton: CustomButton = {
        let button = CustomButton(type: .clickabled, text: "네.있어요")
        button.backgroundColor = .semanticColor.bg.interactive.secondary
        button.setTitleColor(.themeColor(color: .base, value: .value_white), for: .normal)
        return button
    }()
    
    private let descriptionTailImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "description_tail")
        return view
    }()
    
    private let descriptionMainImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "signInDescription_main")
        return view
    }()
    
    private let accountView: SignInAccountView = {
        let view = SignInAccountView()
        view.isHidden = false
        return view
    }()
    
    private let completeButton = CustomButton(type: .disabled, text: "가입 완료")
    
    init(viewModel: SignInSecondViewModel) {
        self.viewModel = viewModel
        super.init()
    }
        
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension SignInSecondViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
}

// MARK: - SetUp
private extension SignInSecondViewController {
    func setUp() {
        accountView.levelTextField.isHidden = false
        
        setUpConstraints()
        setUpNavigation()
        setUpActions()
    }
        
    func setUpConstraints() {
        view.addSubview(firstPageImageView)
        view.addSubview(secondPageImageView)
        view.addSubview(nickNameTextField)
        view.addSubview(accountDescriptionLabel)
        view.addSubview(buttonStackView)
        view.addSubview(descriptionTailImageView)
        view.addSubview(descriptionMainImageView)
        view.addSubview(accountView)
        view.addSubview(completeButton)
        
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
        
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(firstPageImageView.snp.bottom).offset(Constants.spacings.xl)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
        }
        
        accountDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(Constants.spacings.lg)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.height.equalTo(22)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(accountDescriptionLabel.snp.bottom).offset(Constants.spacings.xs)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.height.equalTo(48)
        }
        
        descriptionTailImageView.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(Constants.spacings.xs)
            $0.leading.equalTo(descriptionMainImageView).inset(Constants.spacings.md)
            $0.size.equalTo(12)
        }
        
        descriptionMainImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionTailImageView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl * 2)
            $0.height.equalTo(44)
        }
        
        accountView.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(Constants.spacings.xl_2)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
        }
        
        completeButton.snp.makeConstraints {
            $0.top.equalTo(accountView.snp.bottom).offset(27)
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
        
    }
}

// MARK: - Bind
private extension SignInSecondViewController {
    func bind() {}
}

// MARK: - Method
extension SignInSecondViewController {
    func didTapCompleteButton() {}
    
    @objc
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension SignInSecondViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 엔터
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {}
    
    func textFieldDidBeginEditing(_ textField: UITextField) {}
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
