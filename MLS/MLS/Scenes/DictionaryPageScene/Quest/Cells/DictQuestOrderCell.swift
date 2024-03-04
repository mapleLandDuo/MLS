//
//  DictQuestOrderCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/03.
//

import UIKit

import SnapKit

protocol DictQuestOrderCellDelegate: AnyObject {
    func didTapQuestCell(title: String)
}

class DictQuestOrderCell: UITableViewCell {
    // MARK: Properties
    weak var delegate: DictQuestOrderCellDelegate?
    
    // MARK: Components
    lazy var preQuestButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.themeColor(color: .brand_primary, value: .value_200)?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 12
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let text = self?.preContentLabel.text else { return }
            self?.delegate?.didTapQuestCell(title: text)
        }), for: .touchUpInside)
        return button
    }()
    
    private let preTitleLabel: CustomLabel = {
        let label = CustomLabel(text: "이전 퀘스트", textColor: .semanticColor.text.secondary, font: .customFont(fontSize: .caption_lg, fontType: .medium))
        label.textAlignment = .center
        return label
    }()
    
    private let preContentLabel: CustomLabel = {
        let label = CustomLabel(text: "", textColor: .semanticColor.text.primary, font: .customFont(fontSize: .body_sm, fontType: .semiBold))
        label.numberOfLines = 0
        return label
    }()
    
    lazy var currentQuestButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.themeColor(color: .brand_primary, value: .value_200)?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 12
        button.backgroundColor = .themeColor(color: .brand_primary, value: .value_50)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let text = self?.currentContentLabel.text else { return }
            self?.delegate?.didTapQuestCell(title: text)
        }), for: .touchUpInside)
        return button
    }()
    
    private let currentTitleLabel: CustomLabel = {
        let label = CustomLabel(text: "현재 퀘스트", textColor: .semanticColor.text.interactive.primary, font: .customFont(fontSize: .caption_lg, fontType: .medium))
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private let currentContentLabel: CustomLabel = {
        let label = CustomLabel(text: "", textColor: .semanticColor.text.primary, font: .customFont(fontSize: .body_md, fontType: .semiBold))
        label.numberOfLines = 0
        label.isUserInteractionEnabled = false
        return label
    }()
    
    lazy var laterQuestButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.themeColor(color: .brand_primary, value: .value_200)?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 12
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let text = self?.laterContentLabel.text else { return }
            self?.delegate?.didTapQuestCell(title: text)
        }), for: .touchUpInside)
        return button
    }()
    
    private let laterTitleLabel: CustomLabel = {
        let label = CustomLabel(text: "다음 퀘스트", textColor: .semanticColor.text.secondary, font: .customFont(fontSize: .caption_lg, fontType: .medium))
        label.textAlignment = .center
        return label
    }()
    
    private let laterContentLabel: CustomLabel = {
        let label = CustomLabel(text: "", textColor: .semanticColor.text.primary, font: .customFont(fontSize: .body_sm, fontType: .semiBold))
        label.numberOfLines = 0
        return label
    }()
    
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
        contentView.addSubview(preQuestButton)
        preQuestButton.addSubview(preTitleLabel)
        preQuestButton.addSubview(preContentLabel)
        contentView.addSubview(currentQuestButton)
        currentQuestButton.addSubview(currentTitleLabel)
        currentQuestButton.addSubview(currentContentLabel)
        contentView.addSubview(laterQuestButton)
        laterQuestButton.addSubview(laterTitleLabel)
        laterQuestButton.addSubview(laterContentLabel)
        
        currentQuestButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(40)
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
        
        preQuestButton.snp.makeConstraints {
            $0.top.equalTo(currentQuestButton).offset(10)
            $0.trailing.equalTo(currentQuestButton.snp.leading).inset(-Constants.spacings.md)
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
        
        laterQuestButton.snp.makeConstraints {
            $0.top.equalTo(currentQuestButton).offset(10)
            $0.leading.equalTo(currentQuestButton.snp.trailing).offset(Constants.spacings.md)
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

        preQuestButton.isHidden = preQuest == ""
        preContentLabel.text = preQuest ?? ""

        laterQuestButton.isHidden = laterQuest == ""
        laterContentLabel.text = laterQuest ?? ""
    }
}
