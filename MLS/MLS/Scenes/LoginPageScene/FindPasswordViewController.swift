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
    private let viewModel: SignInFirstViewModel
    
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
    
    func setUpActions() {}
}

// MARK: - Bind
private extension FindPasswordViewController {
    func bind() {}
}

// MARK: - Method
extension FindPasswordViewController {

}

extension FindPasswordViewController: UITextFieldDelegate {
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
