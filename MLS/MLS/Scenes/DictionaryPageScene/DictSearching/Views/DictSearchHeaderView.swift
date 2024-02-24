//
//  DictSearchHeaderView.swift
//  MLS
//
//  Created by SeoJunYoung on 2/24/24.
//

import UIKit

import SnapKit

class DictSearchHeaderView: UIView {
    
    // MARK: - Components

    let searchTrailingView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.semanticColor.bolder.interactive.secondary?.cgColor
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "caret-left"), for: .normal)
        return button
    }()
    
    private let topStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.spacing = Constants.spacings.sm
        return view
    }()
    
    private let searchStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.spacing = Constants.spacings.xs
        return view
    }()
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.tintColor = .semanticColor.bolder.interactive.primary
        textField.font = .customFont(fontSize: .body_md, fontType: .medium)
        return textField
    }()
    
    let searchClearButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close-circle"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
extension DictSearchHeaderView {
    func setUp() {
        setUpConstraints()
    }
    
    func setUpConstraints() {
        
        topStackView.addArrangedSubview(backButton)
        topStackView.addArrangedSubview(searchTrailingView)
        searchStackView.addArrangedSubview(searchTextField)
        searchStackView.addArrangedSubview(searchClearButton)
        searchTrailingView.addSubview(searchStackView)
        self.addSubview(topStackView)
        
        backButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        searchTrailingView.snp.makeConstraints {
            $0.height.equalTo(Constants.spacings.xl_4)
            $0.top.equalToSuperview().inset(Constants.spacings.lg)
            $0.bottom.equalToSuperview().inset(Constants.spacings.xl)
        }
        
        searchClearButton.snp.makeConstraints {
            $0.width.height.equalTo(Constants.spacings.xl)
        }
        
        searchStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.spacings.lg)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.sm)
        }
        
        topStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.spacings.lg)
            $0.leading.equalToSuperview().inset(Constants.spacings.lg)
            $0.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.bottom.equalToSuperview()
        }
    }
}
