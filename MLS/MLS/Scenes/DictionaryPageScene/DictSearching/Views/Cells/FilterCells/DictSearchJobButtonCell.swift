//
//  DictSearchJobButtonCell.swift
//  MLS
//
//  Created by SeoJunYoung on 2/28/24.
//

import UIKit

import SnapKit

class DictSearchJobButtonCell: UICollectionViewCell {
    
    private let jobLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_md, fontType: .semiBold)
        label.textColor = .semanticColor.text.secondary
        label.text = "전사"
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool {
        willSet {
            if newValue {
                self.layer.borderColor = UIColor.semanticColor.bolder.interactive.secondary_pressed?.cgColor
                self.jobLabel.textColor = .semanticColor.text.primary
            } else {
                self.layer.borderColor = UIColor.semanticColor.bolder.secondary?.cgColor
                self.jobLabel.textColor = .semanticColor.text.secondary
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

private extension DictSearchJobButtonCell {
    func setUp() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.semanticColor.bolder.secondary?.cgColor
        self.layer.cornerRadius = 12
        setUpConstraints()
    }
    
    func setUpConstraints() {
        contentView.addSubview(jobLabel)
        jobLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension DictSearchJobButtonCell {
    func bind(job: String) {
        jobLabel.text = job
    }
}
