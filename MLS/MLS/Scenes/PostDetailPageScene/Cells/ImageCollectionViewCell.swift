//
//  File.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/16.
//

import UIKit

import Kingfisher
import SnapKit

class ImageCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties

    // MARK: - Components

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.kf.indicatorType = .activity
        view.contentMode = .scaleAspectFit
        return view
    }()

    // MARK: - LifeCycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ImageCollectionViewCell {
    // MARK: - SetUp

    func setUp() {
        addSubview(imageView)

        imageView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
    }
}

extension ImageCollectionViewCell {
    // MARK: - Method

    func bind(imageUrl: URL?) {
        imageView.kf.setImage(with: imageUrl)
    }
}
