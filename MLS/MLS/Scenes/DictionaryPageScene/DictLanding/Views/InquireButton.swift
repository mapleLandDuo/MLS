//
//  InquireButton.swift
//  MLS
//
//  Created by SeoJunYoung on 2/18/24.
//

import UIKit

import SnapKit

class InquireButton: UIButton {
    // MARK: - Components
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.isUserInteractionEnabled = false
        stackView.spacing = Constants.spacings.xs_2
        return stackView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .caption_lg, fontType: .medium)
        label.text = "문의하기"
        label.textColor = .semanticColor.text.primary
        label.lineBreakMode = .byWordWrapping
        label.addCharacterSpacing()
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "editIcon")
        view.contentMode = .scaleAspectFit
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
private extension InquireButton {
    
    func setUp() {
        setUpConstraints()
        self.backgroundColor = .semanticColor.bg.info_bold
        self.layer.cornerRadius = 12
    }
    
    func setUpConstraints() {
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(iconImageView)
        self.addSubview(stackView)
        
        self.snp.makeConstraints {
            $0.width.equalTo(71)
            $0.height.equalTo(28)
        }
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(12)
        }
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.spacings.xs)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.sm)
        }
    }
}
