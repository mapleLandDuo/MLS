//
//  SharedTextField.swift
//  MLS
//
//  Created by SeoJunYoung on 1/18/24.
//

import UIKit

import SnapKit

// add target -> addaction

class SharedTextField: UIView {
    
    enum TextFieldType {
        case normal
        case password
        case title
        case titlePassword
    }
    // MARK: - Properties
    
    private let type: TextFieldType

    // MARK: - Components

    var textField: UITextField = {
        let view = UITextField()
        view.font = Typography.body1.font
        view.autocapitalizationType = .none
        return view
    }()
    
    lazy var showButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = .systemGray4
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title3.font
        label.textColor = .black
        return label
    }()
    
    lazy var trailingView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.cornerRadius = Constants.defaults.radius
        return view
    }()
    
    lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.body2.font
        return label
    }()
    
    init(type: TextFieldType, placeHolder: String) {
        self.type = type
        super.init(frame: .zero)
        textField.placeholder = placeHolder
        setUp(type: type)
    }
    
    convenience init(type: TextFieldType, placeHolder: String, title: String) {
        self.init(type: type, placeHolder: placeHolder)
        titleLabel.text = title
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension SharedTextField {
    func setUp(type: TextFieldType) {
        setUpLayer(type: type)
        switch type {
        case .normal:
            setUpNormal()
        case .password:
            setUpPassword()
        case .title:
            setUpTitle()
        case .titlePassword:
            setUpTitlePassword()
        }
    }
    
    func setUpLayer(type: TextFieldType) {
        if type != .title, type != .titlePassword {
            layer.borderWidth = 1
            layer.borderColor = UIColor.systemGray4.cgColor
            layer.cornerRadius = Constants.defaults.radius
        }
    }
    
    func setUpNormal() {
        addSubview(textField)
        snp.makeConstraints {
            $0.height.equalTo(Constants.defaults.blockHeight)
        }
        textField.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constants.defaults.horizontal)
        }
    }
    
    func setUpPassword() {
        showButton.addAction(UIAction(handler: { [weak self] _  in
            self?.changeShowButtonColor()
        }), for: .primaryActionTriggered)
        
        textField.isSecureTextEntry = true
        
        addSubview(showButton)
        addSubview(textField)
        snp.makeConstraints {
            $0.height.equalTo(Constants.defaults.blockHeight)
        }
        
        showButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(Constants.screenHeight * 0.03)
        }

        textField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Constants.defaults.vertical)
            $0.leading.bottom.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.trailing.equalTo(showButton.snp.leading)
        }
    }
    
    func setUpTitle() {
        addSubview(titleLabel)
        addSubview(stateLabel)
        addSubview(trailingView)
        trailingView.addSubview(textField)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        stateLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing).offset(Constants.defaults.horizontal)
        }

        trailingView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.defaults.vertical)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(Constants.defaults.blockHeight)
        }

        textField.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constants.defaults.horizontal)
        }
    }
    
    func setUpTitlePassword() {
        textField.isSecureTextEntry = true
        showButton.addAction(UIAction(handler: { [weak self] _  in
            self?.changeShowButtonColor()
        }), for: .primaryActionTriggered)
        
        addSubview(titleLabel)
        addSubview(stateLabel)
        addSubview(trailingView)
        trailingView.addSubview(showButton)
        trailingView.addSubview(textField)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }

        stateLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing).offset(Constants.defaults.horizontal)
        }

        trailingView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.defaults.vertical)
            $0.height.equalTo(Constants.defaults.blockHeight)
            $0.leading.trailing.bottom.equalToSuperview()
        }


        showButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(Constants.screenHeight * 0.03)
        }

        textField.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(Constants.defaults.vertical)
            $0.top.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.trailing.equalTo(showButton.snp.leading)
        }
    }
}

// MARK: - Methods
extension SharedTextField {
    
    private func changeShowButtonColor() {
        textField.isSecureTextEntry.toggle()
        if textField.isSecureTextEntry {
            UIView.animate(withDuration: 0.1) {
                self.showButton.tintColor = .systemGray4
            }
        } else {
            UIView.animate(withDuration: 0.1) {
                self.showButton.tintColor = .systemOrange
            }
        }
    }
    
    func changeBorderColor(color: UIColor, animated: Bool) {
        let action: () -> Void = {
            switch self.type {
            case .normal, .password:
                self.layer.borderColor = color.cgColor
            case .title, .titlePassword:
                self.trailingView.layer.borderColor = color.cgColor
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.4) { action() }
        } else {
            action()
        }
    }
    
    func changeStatelabel(color: UIColor, text: String) {
        stateLabel.text = text
        stateLabel.textColor = color
    }
}
