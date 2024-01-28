//
//  ItemsCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/28.
//

import UIKit

import SnapKit
import Kingfisher

class ItemCollectionViewCell: UICollectionViewCell {
    // MARK: Components
    private let itemImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.alpha = 0.7
        return view
    }()
    
    private let itemTitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.clipsToBounds = true
        label.layer.cornerRadius = Constants.defaults.radius
        return label
    }()
    
    // MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ItemCollectionViewCell {
    // MARK: - SetUp

    func setUp() {
        self.layer.cornerRadius = Constants.defaults.radius
        self.backgroundColor = .red
        
        setUpConstraints()
    }
    
    func setUpConstraints() {
        addSubview(itemImageView)
        itemImageView.addSubview(itemTitleLabel)
        
        itemImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        itemTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension ItemCollectionViewCell {
    // MARK: - Bind

    func bind(item: ItemMenu) {
        itemImageView.kf.setImage(with: item.image)
        itemTitleLabel.text = item.title
    }
}

