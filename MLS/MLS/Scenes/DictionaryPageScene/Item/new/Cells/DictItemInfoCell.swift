//
//  DictItemInfoCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/01.
//

import UIKit

import SnapKit

class DictItemInfoCell: UITableViewCell {
    // MARK: Components

    private let itemImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let nameLabel: CustomLabel = {
        let label = CustomLabel(text: "name", textColor: .semanticColor.text.interactive.inverse, font: .customFont(fontSize: .body_md, fontType: .bold))
        label.backgroundColor = .semanticColor.bg.interactive.secondary_pressed
        label.layer.cornerRadius = 8
        return label
    }()
    
    lazy var descritptionStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [descriptionTextView, expandButton])
        view.axis = .horizontal
        view.spacing = Constants.spacings.sm
        view.backgroundColor = .semanticColor.bg.primary
        view.layer.cornerRadius = 8
        return view
    }()

    private let descriptionTextView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.textContainer.heightTracksTextView = false
        view.font = .customFont(fontSize: .body_sm, fontType: .regular)
        view.textColor = .semanticColor.text.primary
        view.backgroundColor = .clear
        return view
    }()

    private let expandButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        button.setImage(UIImage(systemName: "arrowtriangle.up.fill"), for: .selected)
        return button
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
private extension DictItemInfoCell {
    func setUp() {
        setUpConstraints()
    }

    func setUpConstraints() {
        addSubview(itemImageView)
        addSubview(nameLabel)
        addSubview(descritptionStackView)
        
        itemImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(nameLabel.snp.top).inset(20 + Constants.spacings.xs)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.height.equalTo(32)
        }
        
        descritptionStackView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(Constants.spacings.xs)
            $0.bottom.equalToSuperview().inset(Constants.spacings.xl_2)
        }
        
        descriptionTextView.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        expandButton.snp.makeConstraints {
            $0.size.equalTo(20)
        }
    }
}

// MARK: bind
extension DictItemInfoCell {
    func bind(item: DictionaryItem) {}
}
