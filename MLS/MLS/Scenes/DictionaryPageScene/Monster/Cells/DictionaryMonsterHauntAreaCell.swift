//
//  DictionaryMonsterHauntAreaCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/28/24.
//

import UIKit

class DictionaryMonsterHauntAreaCell: UITableViewCell {
    // MARK: - Properties

    private var hauntAreaArray: Observable<[String]> = Observable([])

    // MARK: - Components

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    private let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        bind()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension DictionaryMonsterHauntAreaCell {

    func setUp() {
        setUpConstraints()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DictionaryMonsterHauntAreaCollectionViewCell.self, forCellWithReuseIdentifier: DictionaryMonsterHauntAreaCollectionViewCell.identifier)
    }

    func setUpConstraints() {
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.defaults.vertical)
            make.height.equalTo(Constants.defaults.blockHeight)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        contentView.addSubview(bottomSeparatorView)
        bottomSeparatorView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
}

extension DictionaryMonsterHauntAreaCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = hauntAreaArray.value?.count else { return 0 }
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DictionaryMonsterHauntAreaCollectionViewCell.identifier, for: indexPath) as? DictionaryMonsterHauntAreaCollectionViewCell else { return UICollectionViewCell() }
        guard let areas = hauntAreaArray.value else { return UICollectionViewCell() }
        cell.bind(area: areas[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let array = hauntAreaArray.value else { return CGSize(width: 0, height: 0) }
        return CGSize(
            width: array[indexPath.row].size(withAttributes: [NSAttributedString.Key.font: Typography.button.font]).width + (Constants.defaults.horizontal * 2),
            height: Constants.defaults.blockHeight)
    }
}

// MARK: - bind
extension DictionaryMonsterHauntAreaCell {
    
    private func bind() {
        hauntAreaArray.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
    func bind(item: DictionaryMonster) {
        hauntAreaArray.value = item.hauntArea
        collectionView.collectionViewLayout.invalidateLayout()
    }
}
