//
//  SignInFirstViewController.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/22.
//

import UIKit

import SafariServices
import SnapKit

class SignInFirstViewController: BasicController {
    // MARK: - Properties

    private let viewModel: SignInFirstViewModel
        
    // MARK: - Components
    
    private let firstPageImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "pagination_first_fill")
        return view
    }()
    
    private let secondPageImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "pagination_second")
        return view
    }()

    private let emailTextField = CustomTextField(type: .normal, header: "이메일", placeHolder: "이메일을 입력해주세요")
    
    private let firstPwTextField: CustomTextField = {
        let textField = CustomTextField(type: .password, header: "비밀번호", placeHolder: "비밀번호를 입력해주세요")
        return textField
    }()
    
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
    
    private let descriptionTailImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "description_tail_red")
        view.isHidden = true
        return view
    }()
    
    private let descriptionMainImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "privacyDescription_main")
        view.isHidden = true
        return view
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
        view.addSubview(descriptionTailImageView)
        view.addSubview(descriptionMainImageView)
        
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
        
        descriptionTailImageView.snp.makeConstraints {
            $0.top.equalTo(privacyButton.snp.bottom)
            $0.leading.equalTo(descriptionMainImageView.snp.leading).offset(Constants.spacings.md)
            $0.size.equalTo(12)
        }
        
        descriptionMainImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionTailImageView.snp.bottom)
            $0.leading.equalTo(privacyButton)
            $0.height.equalTo(44)
            $0.width.equalTo(207)
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
        emailTextField.textField.addAction(UIAction(handler: { [weak self] _ in
            self?.nextButton.type.value = .clickabled
        }), for: .editingChanged)
        
        firstPwTextField.textField.addAction(UIAction(handler: { [weak self] _ in
            self?.nextButton.type.value = .clickabled
        }), for: .editingChanged)
        
        secondPwTextField.textField.addAction(UIAction(handler: { [weak self] _ in
            self?.nextButton.type.value = .clickabled
        }), for: .editingChanged)
        
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
    func bind() {
        viewModel.emailState.bind { [weak self] _ in
            guard let state = self?.viewModel.emailState.value else { return }
            self?.checkEmailField(state: state)
        }
        
        viewModel.firstPwState.bind { [weak self] _ in
            guard let firstState = self?.viewModel.firstPwState.value,
                  let secondState = self?.viewModel.secondPwState.value else { return }
            self?.checkFirstPwField(state: firstState)
            self?.checkSecondPwField(state: secondState)
        }
        
        viewModel.secondPwState.bind { [weak self] _ in
            guard let firstState = self?.viewModel.firstPwState.value,
                  let secondState = self?.viewModel.secondPwState.value else { return }
            self?.checkFirstPwField(state: firstState)
            self?.checkSecondPwField(state: secondState)
        }
    }
}

// MARK: - Method
private extension SignInFirstViewController {
    func didTapPrivacyButton() {
        privacyButton.isSelected = !privacyButton.isSelected
        privacyButton.setImage(privacyButton.isSelected ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square"), for: .normal)
        privacyButton.tintColor = privacyButton.isSelected ? .semanticColor.bg.brand : .semanticColor.bolder.primary
        viewModel.isPrivacyAgree.value?.toggle()
        
        checkPrivacy()
    }
    
    func didTapShowPrivacyButton() {
        guard let privacyPolicyURL = URL(string: "https://plip.kr/pcc/26c2c65d-d3ca-4903-91f2-50a049b20636/privacy/1.html") else { return }
        let safariViewController = SFSafariViewController(url: privacyPolicyURL)
        self.navigationController?.pushViewController(safariViewController, animated: true)
    }
    
    func didTapNextButton() {
        checkPrivacy()
        
        checkTextField(state: viewModel.emailState.value, checkField: checkEmailField, blankState: .emailBlank)
        checkTextField(state: viewModel.firstPwState.value, checkField: checkFirstPwField, blankState: .pwBlank)
        checkTextField(state: viewModel.secondPwState.value, checkField: checkSecondPwField, blankState: .pwBlank)
        
        if viewModel.isValidSignUp() {
            let vc = SignInSecondViewController(viewModel: SignInSecondViewModel())
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func checkPrivacy() {
        guard let isPrivacyAgree = viewModel.isPrivacyAgree.value else { return }
        descriptionTailImageView.isHidden = isPrivacyAgree
        descriptionMainImageView.isHidden = isPrivacyAgree
    }
    
    func checkEmailField(state: TextState) {
        if state == .complete {}
        emailTextField.checkState(state: state, isCorrect: viewModel.isCorrect)
    }
    
    func checkFirstPwField(state: TextState) {
        firstPwTextField.setPasswordFooter(checkPassword: viewModel.checkPassword, state: state)
        if state == .pwBlank {
            firstPwTextField.checkState(state: state, isCorrect: false)
        }
    }
    
    func checkSecondPwField(state: TextState) {
        let isCorrect = state == .complete
        secondPwTextField.checkState(state: state, isCorrect: isCorrect)
    }
    
    func checkTextField(state: TextState?, checkField: (TextState) -> Void, blankState: TextState) {
        if let unwrappedState = state {
            checkField(unwrappedState)
        } else {
            checkField(blankState)
        }
    }
    
    func updateBorderColor(for textField: UITextField, state: TextState) {
        let color: UIColor?
        if state == .complete || state == .default {
            color = UIColor.semanticColor.bolder.interactive.secondary
        } else {
            color = UIColor.semanticColor.bolder.distructive_bold
        }
        textField.superview?.layer.borderColor = color?.cgColor
    }
    
    @objc
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension SignInFirstViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.superview?.layer.borderColor = UIColor.semanticColor.bolder.interactive.primary_pressed?.cgColor
        textField.superview?.layer.borderWidth = 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case emailTextField.textField:
            guard let state = viewModel.emailState.value else { return }
            updateBorderColor(for: textField, state: state)
        case firstPwTextField.textField:
            guard let state = viewModel.firstPwState.value else { return }
            updateBorderColor(for: textField, state: state)
        case secondPwTextField.textField:
            guard let state = viewModel.secondPwState.value else { return }
            updateBorderColor(for: textField, state: state)
        default:
            break
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case emailTextField.textField:
            guard let email = emailTextField.textField.text else { return }
            viewModel.checkEmail(email: email)
        case firstPwTextField.textField:
            guard let password = firstPwTextField.textField.text,
                  let checkPassword = secondPwTextField.textField.text else { return }
            viewModel.checkPassword(password: password)
            viewModel.reCheckPassword(password: password, checkPassword: checkPassword)
        case secondPwTextField.textField:
            guard let password = firstPwTextField.textField.text,
                  let checkPassword = secondPwTextField.textField.text else { return }
            viewModel.reCheckPassword(password: password, checkPassword: checkPassword)
        default:
            break
        }
    }
}
