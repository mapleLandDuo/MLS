//
//  LoginButton.swift
//  MLS
//
//  Created by SeoJunYoung on 2/25/24.
//

import UIKit

import SnapKit

class LoginButton: UIButton {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.isUserInteractionEnabled = false
        view.spacing = Constants.spacings.xs
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "signInIcon")
        return view
    }()
    
    private let labelStackView: UIStackView = {
        let view = UIStackView()
        view.isUserInteractionEnabled = false
        view.spacing = 2
        return view
    }()
    
    private let leftLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .medium)
        label.textColor = .semanticColor.text.primary
        label.text = "회원가입"
        return label
    }()
    
    private let dotImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "circle.fill")
        view.contentMode = .scaleAspectFit
        view.tintColor = .black
        return view
    }()
    
    private let rightLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .medium)
        label.textColor = .semanticColor.text.primary
        label.text = "로그인"
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LoginButton {
    func setUpConstraints() {
        labelStackView.addArrangedSubview(leftLabel)
        labelStackView.addArrangedSubview(dotImage)
        labelStackView.addArrangedSubview(rightLabel)
        stackView.addArrangedSubview(labelStackView)
        stackView.addArrangedSubview(iconImageView)
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(Constants.spacings.xl)
        }
        
        dotImage.snp.makeConstraints {
            $0.width.equalTo(3)
            $0.height.equalTo(20)
        }
        
        
        
    }
}
