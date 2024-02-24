//
//  DictSectionHeaderView.swift
//  MLS
//
//  Created by SeoJunYoung on 2/24/24.
//

import UIKit

import SnapKit

protocol DictSectionHeaderViewDelegate: BasicController {
    func didTapShowButton(title: String?)
}

class DictSectionHeaderView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: DictSectionHeaderViewDelegate?
    
    // MARK: - Components

    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .semanticColor.text.primary
        label.font = .customFont(fontSize: .body_md, fontType: .bold)
        return label
    }()
    
    private let showButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체보기", for: .normal)
        button.setTitleColor(.semanticColor.text.secondary, for: .normal)
        button.titleLabel?.font = .customFont(fontSize: .body_sm, fontType: .medium)
        return button
    }()
    
    init(image: UIImage?, title: String) {
        super.init(frame: .zero)
        iconImageView.image = image
        titleLabel.text = title
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension DictSectionHeaderView {
    
    func setUp() {
        setUpConstraints()
        self.backgroundColor = .white
        showButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.didTapShowButton(title: self?.titleLabel.text)
        }), for: .primaryActionTriggered)
    }
    
    func setUpConstraints() {
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        self.addSubview(showButton)
        
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(Constants.spacings.lg)
            $0.bottom.equalToSuperview().inset(Constants.spacings.lg)
            $0.leading.equalToSuperview().inset(Constants.spacings.xl)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(iconImageView)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(Constants.spacings.xs)
        }
        
        showButton.snp.makeConstraints {
            $0.centerY.equalTo(iconImageView)
            $0.trailing.equalToSuperview().inset(Constants.spacings.xl)
        }
    }
}

