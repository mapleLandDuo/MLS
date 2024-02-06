//
//  MainPageSideMenuFeatureCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/22/24.
//

import UIKit

import SnapKit

class MainPageSideMenuFeatureCell: UITableViewCell {
    // MARK: - Components

    lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
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

// MARK: - Setup
private extension MainPageSideMenuFeatureCell {

    func setUp() {
        contentView.backgroundColor = .systemOrange
    }
}

// MARK: - Method
extension MainPageSideMenuFeatureCell {

    func makeSeparator() {
        contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints {
            $0.leading.equalTo(textLabel!.snp.leading)
            $0.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }

    func removeSeparator() {
        separatorView.removeFromSuperview()
    }
}

// MARK: - Bind
extension MainPageSideMenuFeatureCell {
    
    func bind(data: FeatureCellData) {
        textLabel?.text = data.title
        imageView?.image = data.image
        textLabel?.textColor = .white
        imageView?.tintColor = .white
    }
}
