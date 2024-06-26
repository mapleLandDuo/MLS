//
//  SignInFirstViewController.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/22.
//

import UIKit

import RxCocoa
import RxSwift
import SafariServices
import SnapKit

class SignUpFirstViewController: BasicController {
    // MARK: - Properties

    private let viewModel: SignUpFirstViewModel
        
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
        var config = UIButton.Configuration.plain()
        config.imagePadding = 5
        config.imagePlacement = .leading
        var title = AttributeContainer()
        title.font = .customFont(fontSize: .body_sm, fontType: .medium)
        title.foregroundColor = .semanticColor.text.secondary
        config.attributedTitle = AttributedString("[필수] 개인정보 처리 방침 동의", attributes: title)
        config.image = UIImage(systemName: "square")
        config.baseBackgroundColor = .clear
        button.configuration = config
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
    
    init(viewModel: SignUpFirstViewModel) {
        self.viewModel = viewModel
        super.init()
    }
        
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension SignUpFirstViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
}

// MARK: - SetUp
private extension SignUpFirstViewController {
    func setUp() {
        setUpConstraints()
        setUpNavigation(title: "회원가입")
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
    
    func setUpActions() {
        emailTextField.textField.addAction(UIAction(handler: { [weak self] _ in
            self?.nextButton.type.accept(.clickabled)
        }), for: .editingChanged)
        
        firstPwTextField.textField.addAction(UIAction(handler: { [weak self] _ in
            self?.nextButton.type.accept(.clickabled)
        }), for: .editingChanged)
        
        secondPwTextField.textField.addAction(UIAction(handler: { [weak self] _ in
            self?.nextButton.type.accept(.clickabled)
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
private extension SignUpFirstViewController {
    func bind() {
        viewModel.emailState
            .compactMap { $0 != nil ? $0 : nil }
            .subscribe(onNext: { [weak self] state in
                self?.checkEmailField(state: state!)
            })
        .disposed(by: viewModel.disposeBag)
        
        Observable
            .combineLatest(viewModel.firstPwState, viewModel.secondPwState)
            .compactMap { $0.0 != nil && $0.1 != nil ? ($0.0!, $0.1!) : nil }
            .subscribe(onNext: { [weak self] firstState, secondState in
                self?.checkFirstPwField(state: firstState)
                self?.checkSecondPwField(state: secondState)
            })
            .disposed(by: viewModel.disposeBag)
        
        Observable
            .of(emailTextField.textField.rx.controlEvent(.editingDidBegin).map { self.emailTextField },
                firstPwTextField.textField.rx.controlEvent(.editingDidBegin).map { self.firstPwTextField },
                secondPwTextField.textField.rx.controlEvent(.editingDidBegin).map { self.secondPwTextField })
            .merge()
            .subscribe(onNext: { textField in
                textField.superview?.layer.borderColor = UIColor.semanticColor.bolder.interactive.primary_pressed?.cgColor
                textField.superview?.layer.borderWidth = 1
            })
            .disposed(by: viewModel.disposeBag)
        
        setupTextFieldDidEndEditing(emailTextField.textField, state: viewModel.emailState)
        setupTextFieldDidEndEditing(firstPwTextField.textField, state: viewModel.firstPwState)
        setupTextFieldDidEndEditing(secondPwTextField.textField, state: viewModel.secondPwState)

        emailTextField.textField.rx.text.orEmpty
            .withUnretained(self)
            .subscribe(onNext: { owner, email in
                owner.viewModel.checkEmail(email: email)
            })
            .disposed(by: viewModel.disposeBag)

        Observable
            .combineLatest(firstPwTextField.textField.rx.text, secondPwTextField.textField.rx.text)
            .subscribe(onNext: { [weak viewModel] password, checkPassword in
                viewModel?.checkPassword(password: password ?? "")
                viewModel?.reCheckPassword(password: password ?? "", checkPassword: checkPassword ?? "")
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    func setupTextFieldDidEndEditing(_ textField: UITextField, state: PublishRelay<TextState?>) {
        textField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(state)
            .subscribe(onNext: { [weak self] state in
                guard let state = state else { return }
                self?.updateBorderColor(for: textField, state: state)
            })
            .disposed(by: viewModel.disposeBag)
    }
}

// MARK: - Method
private extension SignUpFirstViewController {
    func didTapPrivacyButton() {
        privacyButton.isSelected = !privacyButton.isSelected
        privacyButton.setImage(privacyButton.isSelected ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square"), for: .normal)
        privacyButton.tintColor = privacyButton.isSelected ? .semanticColor.bg.brand : .semanticColor.bolder.primary
        viewModel.isPrivacyAgree.accept(!viewModel.isPrivacyAgree.value)
        
        checkPrivacy()
    }
    
    func didTapShowPrivacyButton() {
        guard let privacyPolicyURL = URL(string: "https://plip.kr/pcc/26c2c65d-d3ca-4903-91f2-50a049b20636/privacy/1.html") else { return }
        let safariViewController = SFSafariViewController(url: privacyPolicyURL)
        navigationController?.pushViewController(safariViewController, animated: true)
    }
    
    func didTapNextButton() {
        checkPrivacy()
        
        checkTextField(state: viewModel.emailState, checkField: checkEmailField, blankState: .emailBlank)
        checkTextField(state: viewModel.firstPwState, checkField: checkFirstPwField, blankState: .pwBlank)
        checkTextField(state: viewModel.secondPwState, checkField: checkSecondPwField, blankState: .pwBlank)
        
        if viewModel.isValidSignUp() {
            guard let email = emailTextField.textField.text,
                  let password = firstPwTextField.textField.text else { return }
            let vm = SignUpSecondViewModel()
            vm.user.id = email
            vm.password = password
            let vc = SignUpSecondViewController(viewModel: vm)
                
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    /// 개인정보 처리방침을 동의함에 따라 descriptionImageView를 숨기거나 드러냄
    func checkPrivacy() {
        descriptionTailImageView.isHidden = viewModel.isPrivacyAgree.value
        descriptionMainImageView.isHidden = viewModel.isPrivacyAgree.value
    }
    
    func checkEmailField(state: TextState) {
        if state == .complete {}
        emailTextField.checkState(state: state, isCorrect: viewModel.isCorrect)
    }
    
    func checkFirstPwField(state: TextState) {
        firstPwTextField.setPasswordFooter(checkPassword: viewModel.checkPassword)
        if state == .pwBlank {
            firstPwTextField.checkState(state: state, isCorrect: false)
        }
    }
    
    func checkSecondPwField(state: TextState) {
        let isCorrect = state == .complete
        secondPwTextField.checkState(state: state, isCorrect: isCorrect)
    }
    
    func checkTextField(state: PublishRelay<TextState?>, checkField: @escaping (TextState) -> Void, blankState: TextState) {
        state
            .withUnretained(self)
            .subscribe(onNext: { owner, state in
                if let state = state {
                    checkField(state)
                } else {
                    checkField(blankState)
                }
            })
            .disposed(by: viewModel.disposeBag)
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
}
