//
//  FindPasswordViewController.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/23.
//

import UIKit

import SnapKit

class FindPasswordViewController: BasicController {
    // MARK: - Properties
    private let viewModel: FindPasswordViewModel
    
    // MARK: - Components
    private let emailTextField = CustomTextField(type: .normal, header: "비밀번호 변경 요청드릴 이메일을 입력해주세요", placeHolder: "ex) mls@naver.com")
    
    lazy var buttonStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [cancelButton, sendButton])
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.spacing = Constants.spacings.sm
        return view
    }()
    
    private let cancelButton = CustomButton(type: .default, text: "취소")
    
    private let sendButton = CustomButton(type: .disabled, text: "메일 보내기")
    
    init(viewModel: FindPasswordViewModel) {
        self.viewModel = viewModel
        super.init()
    }
        
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension FindPasswordViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
}

// MARK: - SetUp
private extension FindPasswordViewController {
    func setUp() {
        emailTextField.textField.delegate = self
        
        setUpConstraints()
        setUpActions()
    }
        
    func setUpConstraints() {
        view.addSubview(emailTextField)
        view.addSubview(buttonStackView)
        
        emailTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.bottom.equalTo(buttonStackView.snp.top).inset(-Constants.spacings.xl_2)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(Constants.spacings.xl)
            $0.height.equalTo(48)
        }
    }
    
    func setUpActions() {
        cancelButton.addAction(UIAction(handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }), for: .touchUpInside)
        
        sendButton.addAction(UIAction(handler: { [weak self] _ in
            // 이메일 전송
        }), for: .touchUpInside)
    }
}

// MARK: - Bind
private extension FindPasswordViewController {
    func bind() {}
}

// MARK: - Method
private extension FindPasswordViewController {
    func checkEmail(isCorrect: Bool) {
    }
}

extension FindPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        viewModel.checkEmail(email: updatedText) { [weak self] type in
            self?.sendButton.type.value = type
        }
        return true
    }
}
