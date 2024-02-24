//
//  DictSearchMenuCell.swift
//  MLS
//
//  Created by SeoJunYoung on 2/23/24.
//

import UIKit

import SnapKit

class DictSearchMenuCell: UICollectionViewCell {
    
    // MARK: - Components

    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .medium)
        label.textColor = .semanticColor.text.tertiary
        label.addCharacterSpacing()
        label.textAlignment = .center
        return label
    }()
    
    private let selectedLine: UIView = {
        let view = UIView()
        view.backgroundColor = .themeColor(color: .base, value: .value_black)
        view.isHidden = true
        return view
    }()
        
    override var isSelected: Bool {
        willSet {
            if newValue {
                self.textLabel.font = .customFont(fontSize: .body_sm, fontType: .semiBold)
                self.textLabel.textColor = .semanticColor.text.primary
                self.selectedLine.isHidden = false
            } else {
                self.textLabel.font = .customFont(fontSize: .body_sm, fontType: .medium)
                self.textLabel.textColor = .semanticColor.text.tertiary
                self.selectedLine.isHidden = true
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - SetUp
private extension DictSearchMenuCell {
    
    func setUp() {
        setUpConstraints()
    }
    
    func setUpConstraints() {
        contentView.addSubview(textLabel)
        contentView.addSubview(selectedLine)
        
        textLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xs_2)
            $0.top.bottom.equalToSuperview().inset(Constants.spacings.sm)
        }
        
        selectedLine.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(3)
        }
    }
}

extension DictSearchMenuCell {
    func bind(text:String?) {
        textLabel.text = text
    }
}
