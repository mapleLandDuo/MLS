//
//  DictLandingSearchView.swift
//  MLS
//
//  Created by SeoJunYoung on 2/18/24.
//

import UIKit

import SnapKit

protocol DictLandingSearchViewDelegate: BasicController {
    func didTapShortCutButton()
    func didTapSearchButton()
}

class DictLandingSearchView: UIView {
    // MARK: - Properties
    
    weak var delegate: DictLandingSearchViewDelegate?

    // MARK: - Components
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.semanticColor.bolder.interactive.secondary?.cgColor
        button.backgroundColor = .semanticColor.bg.primary

        return button
    }()
    
    private let searchIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "search")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let searchLabel: UILabel = {
        let label = UILabel()
        label.text = "아이템,몬스터,NPC,퀘스트,맵"
        label.textColor = .semanticColor.text.secondary
        label.font = .customFont(fontSize: .body_md, fontType: .medium)
        return label
    }()
    
    private let searchStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = Constants.spacings.xs
        view.isUserInteractionEnabled = false
        return view
    }()

    private let decoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Deco-maple")
        return imageView
    }()
    
    private let orangeLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .caption_lg, fontType: .medium)
        label.text = "메이플랜드"
        label.textColor = .semanticColor.text.interactive.primary
        label.addCharacterSpacing()
        return label
    }()
    
    private let defaultLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .caption_lg, fontType: .medium)
        label.text = "의 전체 컨텐츠를 보고 싶다면?"
        label.textColor = .semanticColor.text.secondary
        label.addCharacterSpacing()
        return label
    }()
    
    private let shortCutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .semanticColor.bg.interactive.secondary_pressed
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.32).cgColor
        button.layer.shadowOffset = .init(width: 2, height: 2)
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 8
        
        return button
    }()
    
    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_md, fontType: .semiBold)
        label.text = "도감 바로가기"
        label.lineBreakMode = .byWordWrapping
        label.addCharacterSpacing()
        label.textColor = .themeColor(color: .base, value: .value_white)
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .semanticColor.bg.primary
        let separator = UIView()
        separator.backgroundColor = .semanticColor.bolder.secondary
        
        view.addSubview(separator)
        separator.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension DictLandingSearchView {
    func setUp() {
        setUpConstraints()
        self.clipsToBounds = true
        self.shortCutButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.didTapShortCutButton()
        }), for: .primaryActionTriggered)
        self.searchButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.didTapSearchButton()
        }), for: .primaryActionTriggered)
    }
    
    func setUpConstraints() {
        
        self.addSubview(searchButton)
        self.addSubview(decoImageView)
        self.addSubview(orangeLabel)
        self.addSubview(defaultLabel)
        self.addSubview(shortCutButton)
        self.addSubview(separatorView)
        shortCutButton.addSubview(buttonLabel)
        searchStackView.addArrangedSubview(searchIcon)
        searchStackView.addArrangedSubview(searchLabel)
        searchButton.addSubview(searchStackView)
        
        searchButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Constants.spacings.xl_2)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.height.equalTo(Constants.spacings.xl_4)
        }
        
        decoImageView.snp.makeConstraints {
            $0.width.equalTo(132)
            $0.height.equalTo(166)
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(80)
        }
        
        orangeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Constants.spacings.xl)
            $0.bottom.equalTo(shortCutButton.snp.bottom)
        }
        
        defaultLabel.snp.makeConstraints {
            $0.leading.equalTo(orangeLabel.snp.trailing)
            $0.bottom.equalTo(shortCutButton.snp.bottom)
        }
        
        shortCutButton.snp.makeConstraints {
            $0.width.equalTo(108)
            $0.height.equalTo(48)
            $0.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.top.equalTo(searchButton.snp.bottom).offset(Constants.spacings.xl_2)
        }
        
        buttonLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constants.spacings.md)
        }
        
        searchIcon.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        searchStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.spacings.lg)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.sm)
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(shortCutButton.snp.bottom).offset(Constants.spacings.xl_2)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(4)
            $0.bottom.equalToSuperview()
        }
    }
}
