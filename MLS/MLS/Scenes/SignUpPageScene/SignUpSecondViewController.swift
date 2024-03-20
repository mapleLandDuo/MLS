//
//  SignInSecondViewController.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/22.
//

import UIKit

import SnapKit

import FirebaseAuth

class SignUpSecondViewController: BasicController {
    // MARK: - Properties

    private let viewModel: SignUpSecondViewModel
        
    // MARK: - Components
    
    private let firstPageImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "pagination_first_fill")
        return view
    }()
    
    private let secondPageImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "pagination_second_fill")
        return view
    }()

    private let nickNameTextField = CustomTextField(type: .normal, header: "사용할 닉네임을 입력해주세요", placeHolder: "닉네임을 입력하세요")
    
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
        button.setButtonClicked(backgroundColor: .semanticColor.bg.interactive.secondary, borderColor: nil, titleColor: .themeColor(color: .base, value: .value_white), clickedBackgroundColor: .semanticColor.bg.interactive.primary_pressed, clickedBorderColor: nil, clickedTitleColor: .themeColor(color: .base, value: .value_white))
        return button
    }()
    
    private let accountButton: CustomButton = {
        let button = CustomButton(type: .clickabled, text: "네.있어요")
        button.backgroundColor = .semanticColor.bg.interactive.secondary
        button.setTitleColor(.themeColor(color: .base, value: .value_white), for: .normal)
        button.setButtonClicked(backgroundColor: .semanticColor.bg.interactive.secondary, borderColor: nil, titleColor: .themeColor(color: .base, value: .value_white), clickedBackgroundColor: .semanticColor.bg.interactive.primary_pressed, clickedBorderColor: nil, clickedTitleColor: .themeColor(color: .base, value: .value_white))
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
    
    private let accountView: SignUpAccountView = {
        let view = SignUpAccountView()
        view.isHidden = true
        return view
    }()
    
    private let completeButton = CustomButton(type: .disabled, text: "가입 완료")
    
    init(viewModel: SignUpSecondViewModel) {
        self.viewModel = viewModel
        super.init()
    }
        
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension SignUpSecondViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
}

// MARK: - SetUp
private extension SignUpSecondViewController {
    func setUp() {
        accountView.levelTextField.isHidden = false
        
        nickNameTextField.textField.delegate = self
        accountView.levelTextField.textField.delegate = self
        accountView.delegate = self
        
        setUpConstraints()
        setUpNavigation(title: "회원가입")
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
    
    func setUpActions() {
        noneAccountButton.addAction(UIAction(handler: { [weak self] _ in
            self?.didTapNoneAccountButton()
        }), for: .touchUpInside)
        
        accountButton.addAction(UIAction(handler: { [weak self] _ in
            self?.didTapAccountButton()
        }), for: .touchUpInside)
        
        completeButton.addAction(UIAction(handler: { [weak self] _ in
            self?.didTapCompleteButton()
        }), for: .touchUpInside)
    }
}

// MARK: - Bind
private extension SignUpSecondViewController {
    func bind() {
        viewModel.nickNameState.bind { [weak self] _ in
            self?.activeCompleteButton()
            guard let state = self?.viewModel.nickNameState.value else { return }
            if state != .default {
                let isCorrect = state == .complete
                self?.nickNameTextField.checkState(state: state, isCorrect: isCorrect)
            }
        }
        
        viewModel.levelState.bind { [weak self] _ in
            self?.activeCompleteButton()
            if let state = self?.viewModel.levelState.value {
                if state == .default {
                    self?.accountView.levelTextField.setLevelField()
                } else {
                    let isCorrect = state == .complete
                    self?.accountView.levelTextField.checkState(state: state, isCorrect: isCorrect)
                }
            } else {
                self?.accountView.levelTextField.footerLabel.isHidden = false
            }
        }
        
        viewModel.isAccountExist.bind { [weak self] _ in
            self?.activeCompleteButton()
        }
        
        viewModel.job.bind { [weak self] _ in
            self?.activeCompleteButton()
        }
    }
}

// MARK: - Methods
private extension SignUpSecondViewController {
    func didTapNoneAccountButton() {
        setAccountButton(isExist: false)
        viewModel.isAccountExist.value = false
    }
    
    func didTapAccountButton() {
        setAccountButton(isExist: true)
        viewModel.isAccountExist.value = true
    }

    func didTapCompleteButton() {
        viewModel.isValidSignUp { [weak self] state in
            switch state {
            case .complete:
                self?.trySignUp()
            case .nickNameExist, .nickNameNotCorrect:
                self?.nickNameTextField.checkState(state: state, isCorrect: false)
            case .lvNotInt, .lvOutOfBounds:
                self?.accountView.levelTextField.checkState(state: state, isCorrect: false)
            default:
                break
            }
        }
    }
    
    /// 계정이 있으면 추가 정보를 입력하는 accountView를 보여주고 계정이 없으면 descriptionImageView를 보여줌
    /// - Parameter isExist: 계정이 있으면 true, 없으면 false
    func setAccountButton(isExist: Bool) {
        descriptionMainImageView.isHidden = isExist
        descriptionTailImageView.isHidden = isExist
        accountView.isHidden = !isExist

        noneAccountButton.isClicked.value = !isExist
        accountButton.isClicked.value = isExist
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
    
    func activeCompleteButton() {
        viewModel.isComplete { [weak self] isComplete in
            if isComplete {
                self?.completeButton.type.value = .clickabled
            } else {
                self?.completeButton.type.value = .disabled
            }
        }
    }
    
   func trySignUp() {
        guard let nickName = nickNameTextField.textField.text,
       let isAccountExist = viewModel.isAccountExist.value else { return }

        var level: Int? = nil
        var job: Job? = nil

        if isAccountExist {
            guard let levelText = accountView.levelTextField.textField.text,
                  let jobValue = viewModel.job.value else { return }
            level = Int(levelText)
            job = jobValue
        }

        viewModel.user.nickName = nickName
        viewModel.user.level = level
        viewModel.user.job = job
       
       IndicatorManager.showIndicator(vc: self)
       viewModel.trySignUp(email: viewModel.user.id, password: viewModel.password, nickName: nickName) { [weak self] isSuccess, errorMessage in
           guard let self = self else { return }
            if isSuccess {
                Auth.auth().signIn(withEmail: self.viewModel.user.id, password: self.viewModel.password) { _, error in
                    if error == nil {
                        IndicatorManager.hideIndicator(vc: self)
                        AlertMaker.showAlertAction1(vc: self, title: "회원가입 성공", message: "확인버튼을 누르면 메인으로 돌아갑니다.") {
                            LoginManager.manager.email = Auth.auth().currentUser?.email
                            self.changeRootViewController()
                        }
                    }
                }
            } else {
                AlertMaker.showAlertAction1(vc: self, title: "회원가입 실패", message: errorMessage)
                IndicatorManager.hideIndicator(vc: self)
            }
        }
    }
    
    /// 회원가입이 완료되면 rootVC를 변경
    func changeRootViewController() {
        let vc = DictLandingViewController(viewModel: DictLandingViewModel())
        let navigationController = UINavigationController(rootViewController: vc)
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

extension SignUpSecondViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.superview?.layer.borderColor = UIColor.semanticColor.bolder.interactive.primary_pressed?.cgColor
        textField.superview?.layer.borderWidth = 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case nickNameTextField.textField:
            guard let state = viewModel.nickNameState.value else { return }
            if state == .default {
                updateBorderColor(for: textField, state: .nickNameNotCorrect)
            } else {
                updateBorderColor(for: textField, state: state)
            }
        case accountView.levelTextField.textField:
            guard let state = viewModel.levelState.value else { return }
            updateBorderColor(for: textField, state: state)
        default:
            break
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == nickNameTextField.textField {
            guard let text = textField.text else { return }
            viewModel.checkNickName(nickName: text)
        } else {
            guard let text = textField.text else { return }
            viewModel.checkLevel(level: text)
        }
    }
}

extension SignUpSecondViewController: SignUpAccountViewDelegate {
    func didtapJobButton(job: String) {
        switch job {
        case "전사":
            viewModel.job.value = .warrior
        case "궁수":
            viewModel.job.value = .archer
        case "도적":
            viewModel.job.value = .thief
        case "법사":
            viewModel.job.value = .mage
        default:
            break
        }
    }
}
