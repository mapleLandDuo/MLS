//
//  DictTagCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/02.
//

import UIKit

import SnapKit

class DictTagCell: UICollectionViewCell {
    // MARK: Components
    
    private let leadingView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .themeColor(color: .base, value: .value_white)
        view.layer.borderColor = UIColor.semanticColor.bolder.primary?.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        return view
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .medium)
        label.textColor = .semanticColor.text.primary
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
  
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: SetUp
extension DictTagCell {
    func setUp() {
        setConstraint()
    }
  
    func setConstraint() {
        addSubview(leadingView)
        leadingView.addSubview(tagLabel)
        
        leadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        tagLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.spacings.xs)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.md)
        }
    }
}

// MARK: Bind
extension DictTagCell {
    func bind(item: String) {
        tagLabel.text = item
    }
}
