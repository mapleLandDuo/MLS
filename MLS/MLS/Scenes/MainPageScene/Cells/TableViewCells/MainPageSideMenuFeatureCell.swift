//
//  MainPageSideMenuFeatureCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/22/24.
//

import UIKit
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MainPageSideMenuFeatureCell {
    // MARK: - Setup

    func setUp() {
        contentView.backgroundColor = .systemOrange
    }
}
extension MainPageSideMenuFeatureCell {
    // MARK: - Method

    func makeSeparator() {
        contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.left.equalTo(textLabel!.snp.left)
            make.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func bind(data: FeatureCellData) {
        textLabel?.text = data.title
        imageView?.image = data.image
        textLabel?.textColor = .white
        imageView?.tintColor = .white
    }
}
