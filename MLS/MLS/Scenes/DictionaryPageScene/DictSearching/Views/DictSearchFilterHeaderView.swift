//
//  DictSearchFilterHeaderView.swift
//  MLS
//
//  Created by SeoJunYoung on 2/27/24.
//

import UIKit

import SnapKit

protocol DictSearchFilterHeaderViewDelegate: BasicController {
    func didTapFilterButton(type: DictType)
    func didTapFilterResetButton(type: DictType)
    func didTapSortedButton(type: DictType)
}

class DictSearchFilterHeaderView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: DictSearchFilterHeaderViewDelegate?
    
    private let type: DictType
    
    // MARK: - Components

    private let filterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .semanticColor.bg.primary
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.semanticColor.bolder.primary?.cgColor
        return button
    }()
    
    private let filterButtonImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "funnelIcon"))
        return view
    }()
    

    private let resetButtonImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "refreshIcon"))
        return view
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let sortedButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let sortedButtonStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = Constants.spacings.xs
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let sortedLabel: UILabel = {
        let label = UILabel()
        label.text = "레벨 높은 순"
        label.font = .customFont(fontSize: .body_sm, fontType: .medium)
        label.textColor = .semanticColor.text.primary
        return label
    }()
    
    private let sortedDownImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "downIcon"))
        return view
    }()
    
    init(selectedMenuIndex: Int, sorted: DictSearchSortedEnum) {
        switch selectedMenuIndex {
        case 1:
            self.type = .monster
        case 2:
            self.type = .item
        case 3:
            self.type = .map
        case 4:
            self.type = .npc
        case 5:
            self.type = .quest
        default:
            self.type = .item
        }
        sortedLabel.text = sorted.rawValue
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension DictSearchFilterHeaderView {
    
    func setUp() {
        setUpConstraints()
        self.backgroundColor = .white
        
        filterButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            delegate?.didTapFilterButton(type: self.type)
        }), for: .primaryActionTriggered)
        
        resetButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            delegate?.didTapFilterResetButton(type: self.type)
        }), for: .primaryActionTriggered)
        
        sortedButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            delegate?.didTapSortedButton(type: self.type)
        }), for: .primaryActionTriggered)
    }
    
    func setUpConstraints() {
        self.addSubview(filterButton)
        filterButton.addSubview(filterButtonImageView)
        
        self.addSubview(resetButton)
        resetButton.addSubview(resetButtonImageView)
        
        self.addSubview(sortedButton)
        sortedButtonStackView.addArrangedSubview(sortedLabel)
        sortedButtonStackView.addArrangedSubview(sortedDownImage)
        sortedButton.addSubview(sortedButtonStackView)
        
        filterButton.snp.makeConstraints {
            $0.size.equalTo(Constants.spacings.xl_3)
            $0.top.equalToSuperview().inset(Constants.spacings.lg)
            $0.leading.equalToSuperview().inset(Constants.spacings.xl)
        }
        
        filterButtonImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        resetButton.snp.makeConstraints {
            $0.centerY.equalTo(filterButton)
            $0.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.size.equalTo(Constants.spacings.xl_3)
        }
        
        resetButtonImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        sortedButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(Constants.spacings.lg)
            $0.trailing.equalToSuperview().inset(Constants.spacings.xl)
        }
        
        sortedButtonStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        sortedDownImage.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        

    }
}

