//
//  DictQuestOrderCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/03.
//

import UIKit

import SnapKit

class DictQuestOrderCell: UITableViewCell {
    // MARK: Components
    private let preQuestView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.themeColor(color: .brand_primary, value: .value_200)?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let preTitleLabel: CustomLabel = {
        let label = CustomLabel(text: "이전 퀘스트", textColor: .semanticColor.text.secondary, font: .customFont(fontSize: .caption_lg, fontType: .medium))
        label.textAlignment = .center
        return label
    }()
    
    private let preContentLabel = CustomLabel(text: "", textColor: .semanticColor.text.primary ,font: .customFont(fontSize: .body_sm, fontType: .semiBold))
    
    private let currentQuestView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.themeColor(color: .brand_primary, value: .value_200)?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 12
        view.backgroundColor = .themeColor(color: .brand_primary, value: .value_50)
        return view
    }()
    
    private let currentTitleLabel: CustomLabel = {
        let label = CustomLabel(text: "현재 퀘스트", textColor: .semanticColor.text.interactive.primary, font: .customFont(fontSize: .caption_lg, fontType: .medium))
        label.textAlignment = .center
        return label
    }()
    
    private let currentContentLabel = CustomLabel(text: "", textColor: .semanticColor.text.primary ,font: .customFont(fontSize: .body_md, fontType: .semiBold))
    
    private let laterQuestView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.themeColor(color: .brand_primary, value: .value_200)?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let laterTitleLabel: CustomLabel = {
        let label = CustomLabel(text: "다음 퀘스트", textColor: .semanticColor.text.secondary, font: .customFont(fontSize: .caption_lg, fontType: .medium))
        label.textAlignment = .center
        return label
    }()
    
    private let laterContentLabel = CustomLabel(text: "", textColor: .semanticColor.text.primary ,font: .customFont(fontSize: .body_sm, fontType: .semiBold))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: SetUp
private extension DictQuestOrderCell {
    func setUp() {
        setUpConstraints()
    }

    func setUpConstraints() {
        addSubview(preQuestView)
        preQuestView.addSubview(preTitleLabel)
        preQuestView.addSubview(preContentLabel)
        addSubview(currentQuestView)
        currentQuestView.addSubview(currentTitleLabel)
        currentQuestView.addSubview(currentContentLabel)
        addSubview(laterQuestView)
        laterQuestView.addSubview(laterTitleLabel)
        laterQuestView.addSubview(laterContentLabel)
        
        currentQuestView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(150)
            $0.height.equalTo(200)
        }
        
        currentTitleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(Constants.spacings.lg)
            $0.bottom.equalTo(currentContentLabel.snp.top).offset(-Constants.spacings.sm)
        }
        
        currentContentLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.lg)
            $0.bottom.lessThanOrEqualToSuperview().inset(Constants.spacings.xl_3)
        }
        
        preQuestView.snp.makeConstraints {
            $0.top.equalTo(currentQuestView).offset(10)
            $0.trailing.equalTo(currentQuestView.snp.leading).inset(-Constants.spacings.md)
            $0.width.equalTo(150)
            $0.height.equalTo(180)
        }
        
        preTitleLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(Constants.spacings.lg)
            $0.bottom.equalTo(preContentLabel.snp.top).offset(-Constants.spacings.sm)
        }
        
        preContentLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.lg)
            $0.bottom.lessThanOrEqualToSuperview().inset(Constants.spacings.xl_3)
        }
        
        laterQuestView.snp.makeConstraints {
            $0.top.equalTo(currentQuestView).offset(10)
            $0.leading.equalTo(currentQuestView.snp.trailing).offset(Constants.spacings.md)
            $0.width.equalTo(150)
            $0.height.equalTo(180)
        }
        
        laterTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(Constants.spacings.lg)
            $0.bottom.equalTo(laterContentLabel.snp.top).offset(-Constants.spacings.sm)
        }
        
        laterContentLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.lg)
            $0.bottom.lessThanOrEqualToSuperview().inset(Constants.spacings.xl_3)
        }
    }
}

// MARK: bind
extension DictQuestOrderCell {
    func bind(preQuest: String?, currentQuest: String, laterQuest: String?) {
        currentContentLabel.text = currentQuest

        preQuestView.isHidden = preQuest == nil
        preContentLabel.text = preQuest ?? ""

        laterQuestView.isHidden = laterQuest == nil
        laterContentLabel.text = laterQuest ?? ""
    }
}
