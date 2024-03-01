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
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        return label
    }()
    
    lazy var descritptionView: UIView = {
        let view = UIView()
        view.backgroundColor = .semanticColor.bg.primary
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let descriptionTextLabel: UILabel = {
        let view = UILabel()
        view.font = .customFont(fontSize: .body_sm, fontType: .regular)
        view.textColor = .semanticColor.text.primary
        view.backgroundColor = .clear
        return view
    }()

    private let expandButton: UIButton = {
        let button = UIButton()
        button.tintColor = .semanticColor.text.primary
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
        addSubview(descritptionView)
        descritptionView.addSubview(descriptionTextLabel)
        descritptionView.addSubview(expandButton)
        
        itemImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.bottom.equalTo(nameLabel.snp.top).inset(-44)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(80)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.height.equalTo(32)
        }
        
        descritptionView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(Constants.spacings.xs)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.height.equalTo(60)
            $0.bottom.equalToSuperview().inset(Constants.spacings.xl_2)
        }
        
        descriptionTextLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.spacings.sm)
            $0.leading.equalToSuperview().inset(Constants.spacings.lg)
        }
        
        expandButton.snp.makeConstraints {
            $0.leading.equalTo(descriptionTextLabel.snp.trailing).offset(Constants.spacings.sm)
            $0.trailing.equalToSuperview().inset(Constants.spacings.lg)
            $0.width.equalTo(12)
            $0.height.equalTo(10)
            $0.centerY.equalToSuperview()
        }
        
        expandButton.contentHuggingPriority(for: .horizontal)
    }
}

// MARK: bind
extension DictItemInfoCell {
    func bind(item: DictItem) {
        itemImageView.kf.setImage(with: URL(string: "https://maplestory.io/api/gms/62/item/\(item.code)/icon?resize=2"))
        nameLabel.text = item.name
        descriptionTextLabel.text = item.detailValues.filter{ $0.name == "설명" }.first?.description
        print(item.detailValues.filter{ $0.name == "설명" }.first?.description)
    }
}
