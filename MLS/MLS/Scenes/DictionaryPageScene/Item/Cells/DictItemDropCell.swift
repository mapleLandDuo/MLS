//
//  DictItemDropCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/01.
//

import UIKit

import SnapKit

protocol DictItemDropCellDelegate: AnyObject {
    func didTapItemDropCell(title: String)
}

class DictItemDropCell: UITableViewCell {
    // MARK: Properties
    weak var delegate: DictItemDropCellDelegate?
    
    private var items: [DictDropContent]?

    // MARK: Components
    private let dropCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 120, height: 216)
        layout.minimumLineSpacing = Constants.spacings.xl_3
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.register(DropCollectionViewCell.self, forCellWithReuseIdentifier: DropCollectionViewCell.identifier)
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

// MARK: SetUp
private extension DictItemDropCell {
    func setUp() {
        dropCollectionView.delegate = self
        dropCollectionView.dataSource = self
        
        setUpConstraints()
    }

    func setUpConstraints() {
        addSubview(dropCollectionView)
        
        dropCollectionView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.spacings.lg)
            $0.leading.trailing.equalToSuperview().inset(47.5)
        }
    }
}

// MARK: bind
extension DictItemDropCell {
    func bind(items: [DictDropContent]?) {
        if let items = items {
            self.items = items
            dropCollectionView.snp.remakeConstraints {
                $0.top.bottom.equalToSuperview().inset(Constants.spacings.lg)
                $0.leading.trailing.equalToSuperview().inset(47.5)
                $0.height.equalTo(216 * (items.count / 2 + items.count % 2) + Int(Constants.spacings.xl_3) * ((items.count / 2 + items.count % 2) - 1))
            }
            dropCollectionView.reloadData()
        }
    }
}

extension DictItemDropCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = items?.count else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DropCollectionViewCell.identifier, for: indexPath) as? DropCollectionViewCell else { return UICollectionViewCell() }
        guard let item = items?[indexPath.row] else { return UICollectionViewCell()}
        cell.bind(data: item, type: .monster)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = items?[indexPath.row] else { return }
        delegate?.didTapItemDropCell(title: item.name)
    }
}
