//
//  PopUpView.swift
//  MLS
//
//  Created by SeoJunYoung on 2/21/24.
//

import UIKit

import SnapKit

class PopUpView: UIView {
    
    // MARK: - Components

    private let backGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .themeColor(color: .base, value: .value_black)
        view.alpha = 0.5
        return view
    }()
    
    private let popUpView: UIView = {
        let view = UIView()
        view.backgroundColor = .themeColor(color: .base, value: .value_white)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .themeColor(color: .brand_primary, value: .value_50)
        return view
    }()
    
    private let headerLeftButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_md, fontType: .semiBold)
        label.textColor = .semanticColor.text.primary
        return label
    }()
    
    private let headerRightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close-circle"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let headerStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .equalSpacing
        return view
    }()
    
    private let headerSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .semanticColor.bolder.secondary
        return view
    }()
    
    private let textView: UITextView = {
        let view = UITextView()
        view.font = .customFont(fontSize: .body_sm, fontType: .regular)
        return view
    }()
    
    init(title:String, content: String) {
        super.init(frame: .zero)
        setUp()
        headerLabel.text = title
        textView.text = content
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension PopUpView {
    
    func setUp() {
        setUpConstraints()
        self.frame = .init(x: 0, y: 0, width: Constants.screenWidth, height: Constants.screenHeight)
        headerRightButton.addAction(UIAction(handler: { [weak self] _ in
            self?.removeFromSuperview()
        }), for: .primaryActionTriggered)
    }
    
    func setUpConstraints() {
        self.addSubview(backGroundView)
        self.addSubview(popUpView)
        popUpView.addSubview(headerView)
        popUpView.addSubview(textView)
        headerStackView.addArrangedSubview(headerLeftButton)
        headerStackView.addArrangedSubview(headerLabel)
        headerStackView.addArrangedSubview(headerRightButton)
        headerView.addSubview(headerStackView)
        headerView.addSubview(headerSeparator)
        
        backGroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.spacings.xl_4)
        }
        
        headerLeftButton.snp.makeConstraints {
            $0.height.width.equalTo(Constants.spacings.xl)
        }
        
        headerRightButton.snp.makeConstraints {
            $0.height.width.equalTo(Constants.spacings.xl)
        }
        
        headerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constants.spacings.lg)
        }
        
        headerSeparator.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(Constants.spacings.lg)
            $0.height.equalTo(440)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.lg)
            $0.bottom.equalToSuperview().inset(Constants.spacings.xl)
        }
        
        popUpView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
        }
    }
}
