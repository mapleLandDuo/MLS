//
//  File.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/28.
//

import UIKit

import SnapKit

class ItemTableViewCell: UITableViewCell {
    // MARK: Properties

    private var itemMenus: [ItemMenu]?

    // MARK: Components

    private let itemCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.defaults.horizontal
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ItemTableViewCell {
    // MARK: SetUp

    func setUp() {
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self

        setupConstraints()
    }

    func setupConstraints() {
        addSubview(itemCollectionView)

        itemCollectionView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.height.equalTo(((Constants.screenWidth - Constants.defaults.horizontal * 5) / 2) * 3 + (Constants.defaults.vertical * 3))
        }
    }
}

extension ItemTableViewCell {
    // MARK: Bind

    func bind(itemMenus: [ItemMenu]) {
        self.itemMenus = itemMenus
    }
}

extension ItemTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let itemMenus = itemMenus else { return 0 }
        return itemMenus.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = itemCollectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as? ItemCollectionViewCell,
              let item = itemMenus?[indexPath.row] else { return UICollectionViewCell() }
        cell.bind(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (Constants.screenWidth - Constants.defaults.horizontal * 5) / 2, height: (Constants.screenWidth - Constants.defaults.horizontal * 5) / 2)
        }
}
