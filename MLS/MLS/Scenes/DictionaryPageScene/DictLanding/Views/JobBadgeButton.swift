//
//  JobBadgeButton.swift
//  MLS
//
//  Created by SeoJunYoung on 2/18/24.
//

import UIKit

import SnapKit

class JobBadgeButton: UIButton {
    // MARK: - Components
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.isUserInteractionEnabled = false
        view.spacing = Constants.spacings.xs_2
        view.axis = .horizontal
        return view
    }()
    
    private let jobLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .caption_lg, fontType: .regular)
        label.textColor = .semanticColor.text.primary
        label.addCharacterSpacing()
        return label
    }()
    
    private let dotImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Ellipse 1")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .caption_lg, fontType: .regular)
        label.textColor = .semanticColor.text.primary
        label.addCharacterSpacing()
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
private extension JobBadgeButton {
    
    func setUp() {
        setUpConstraints()
        self.layer.cornerRadius = 12
    }
    
    func setUpConstraints() {
        
        stackView.addArrangedSubview(jobLabel)
        stackView.addArrangedSubview(dotImage)
        stackView.addArrangedSubview(levelLabel)
        self.addSubview(stackView)
        
        self.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.spacings.xs_2)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.sm)
        }
        dotImage.snp.makeConstraints {
            $0.width.height.equalTo(Constants.spacings.xs_2)
        }
    }
}

extension JobBadgeButton {
    func reset(user: User) {
        if let job = user.job {
            self.jobLabel.text = job.rawValue
            guard let level = user.level else { return }
            self.levelLabel.text = String(level)
            switch job {
            case .warrior:
                self.backgroundColor = .themeColor(color: .brand_primary, value: .value_200)
            case .mage:
                self.backgroundColor = .themeColor(color: .brand_primary, value: .value_200)
            case .thief:
                self.backgroundColor = .themeColor(color: .brand_primary, value: .value_200)
            case .archer:
                self.backgroundColor = .themeColor(color: .brand_primary, value: .value_200)
            }
            stackView.addArrangedSubview(dotImage)
            stackView.addArrangedSubview(levelLabel)
        } else {
            self.jobLabel.text = "미설정"
            self.backgroundColor = .semanticColor.bg.secondary
            dotImage.removeFromSuperview()
            levelLabel.removeFromSuperview()
            jobLabel.textAlignment = .center
        }
    }
}
