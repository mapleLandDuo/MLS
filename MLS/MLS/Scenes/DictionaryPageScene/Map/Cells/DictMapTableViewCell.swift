//
//  DictMapToMonsterCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/02.
//

import UIKit

import SnapKit

protocol DictMapTableViewCellDelegate: AnyObject {
    func didTapMapTableCell(title: String)
}

class DictMapTableViewCell: UITableViewCell {
    // MARK: Properties
    weak var delegate: DictMapTableViewCellDelegate?
    
    private var items: [DictDropContent]?

    private var type: DictType?

    // MARK: Components
    private let dropCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 120, height: 216)
        layout.minimumLineSpacing = Constants.spacings.xl_3
        layout.minimumInteritemSpacing = Constants.spacings.lg
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
private extension DictMapTableViewCell {
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
extension DictMapTableViewCell {
    func bind(items: [DictDropContent]?, type: DictType?) {
        if let items = items {
            self.items = items
            self.type = type
            dropCollectionView.snp.remakeConstraints {
                $0.top.bottom.equalToSuperview().inset(Constants.spacings.lg)
                $0.leading.trailing.equalToSuperview().inset(47.5)
                $0.height.equalTo(216 * (items.count / 2 + items.count % 2) + Int(Constants.spacings.xl_3) * ((items.count / 2 + items.count % 2) - 1))
            }
            dropCollectionView.reloadData()
        } else {
            dropCollectionView.isHidden = true
            // alert
        }
    }
}

extension DictMapTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = items?.count else { return 0 }
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DropCollectionViewCell.identifier, for: indexPath) as? DropCollectionViewCell,
              let item = items?[indexPath.row],
              let type = self.type else { return UICollectionViewCell() }
        cell.bind(data: item, type: type)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = items?[indexPath.row] else { return }
        delegate?.didTapMapTableCell(title: item.name)
    }
}
