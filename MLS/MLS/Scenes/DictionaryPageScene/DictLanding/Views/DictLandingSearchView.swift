//
//  DictLandingSearchView.swift
//  MLS
//
//  Created by SeoJunYoung on 2/18/24.
//

import UIKit

import SnapKit

class DictLandingSearchView: UIView {
    // MARK: - Components
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.layer.borderWidth = 1
        searchBar.layer.cornerRadius = 12
        searchBar.placeholder = "아이템, 몬스터, NPC, 퀘스트, 맵"
        return searchBar
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
        label.addCharacterSpacing()
        return label
    }()
    
    private let defaultLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .caption_lg, fontType: .medium)
        label.text = "의 전체 컨텐츠를 보고 싶다면?"
        label.addCharacterSpacing()
        return label
    }()
    
    private let shortCutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
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
        label.textColor = .white
        return label
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
    }
    
    func setUpConstraints() {
        
        self.addSubview(searchBar)
        self.addSubview(decoImageView)
        self.addSubview(orangeLabel)
        self.addSubview(defaultLabel)
        self.addSubview(shortCutButton)
        shortCutButton.addSubview(buttonLabel)
        
        searchBar.snp.makeConstraints {
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
            $0.bottom.equalToSuperview().inset(Constants.spacings.xl_2)
        }
        
        defaultLabel.snp.makeConstraints {
            $0.leading.equalTo(orangeLabel.snp.trailing)
            $0.bottom.equalToSuperview().inset(Constants.spacings.xl_2)
        }
        
        shortCutButton.snp.makeConstraints {
            $0.width.equalTo(108)
            $0.height.equalTo(48)
            $0.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.bottom.equalToSuperview().inset(Constants.spacings.xl_2)
        }
        
        buttonLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constants.spacings.md)
        }
    }
}
