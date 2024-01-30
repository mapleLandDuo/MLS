//
//  DetailImageCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/26.
//

import UIKit

import SnapKit

class DetailImageCell: UITableViewCell {
    // MARK: Properties

    private var images: [URL?]?

    // MARK: Components

    private let imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        view.backgroundColor = .black
        view.isPagingEnabled = true
        view.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        return view
    }()

    // MARK: LifeCycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DetailImageCell {
    // MARK: SetUp

    func setUp() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self

        setupConstraints()
    }

    func setupConstraints() {
        addSubview(imageCollectionView)

        imageCollectionView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
    }
}

extension DetailImageCell {
    // MARK: Bind

    func bind(images: [URL?]?) {
        if let images = images {
            self.images = images
        }
    }
}

extension DetailImageCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        cell.bind(imageUrl: images?[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.screenWidth, height: Constants.screenHeight)
    }
}
