//
//  RecentSearchKeywordCell.swift
//  MLS
//
//  Created by SeoJunYoung on 2/23/24.
//

import UIKit

import SnapKit

protocol RecentSearchKeywordCellDelegate: BasicController {
    func didTapDeleteButton(index: Int)
}

class RecentSearchKeywordCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    weak var delegate: RecentSearchKeywordCellDelegate?
    
    private var index = 0
    
    // MARK: - Components

    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .medium)
        label.textColor = .semanticColor.text.primary
        return label
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = Constants.spacings.xs_2
        return view
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

// MARK: - SetUp
private extension RecentSearchKeywordCell {
    func setUp() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.semanticColor.bolder.primary?.cgColor
        contentView.layer.cornerRadius = 12
        setUpConstraints()
        deleteButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.didTapDeleteButton(index: self.index)
        }), for: .primaryActionTriggered)
    }
    
    func setUpConstraints() {
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(deleteButton)
        contentView.addSubview(stackView)
        
        deleteButton.snp.makeConstraints {
            $0.width.height.equalTo(Constants.spacings.xl)
        }
        
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.spacings.xs)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.md)
        }
    }
}

// MARK: - Bind
extension RecentSearchKeywordCell {
    func bind(text:String?, index:Int) {
        textLabel.text = text
        self.index = index
    }
}
