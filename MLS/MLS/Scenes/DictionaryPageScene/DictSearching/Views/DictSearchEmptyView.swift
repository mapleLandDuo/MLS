//
//  SearchEmptyView.swift
//  MLS
//
//  Created by SeoJunYoung on 2/24/24.
//

import UIKit

import SnapKit

class DictSearchEmptyView: UIView {
    
    // MARK: - Components

    private let searchResultEmptyImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "SearchResultEmpty")
        return view
    }()
    
    private let searchResultEmptyLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_lg, fontType: .semiBold)
        label.text = "검색 결과가 없어요"
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension DictSearchEmptyView {
    func setUp() {
        setUpConstraints()
    }
    
    func setUpConstraints() {
        self.addSubview(searchResultEmptyImageView)
        self.addSubview(searchResultEmptyLabel)
        
        searchResultEmptyImageView.snp.makeConstraints {
            $0.width.equalTo(48)
            $0.height.equalTo(64)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(128)
        }
        
        searchResultEmptyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(searchResultEmptyImageView.snp.bottom).offset(Constants.spacings.lg)
        }
    }
}
