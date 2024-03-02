//
//  DictHorizontalSectionTableViewCell.swift
//  MLS
//
//  Created by SeoJunYoung on 2/19/24.
//

import UIKit

import SnapKit

protocol DictHorizontalSectionTableViewCellDelegate: BasicController {
    func didSelectItemAt(itemTitle: String, type: DictType)
}

class DictHorizontalSectionTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    private var datas: Observable<[DictSectionData]> = Observable([])

    weak var delegate: DictHorizontalSectionTableViewCellDelegate?
    
    // MARK: - Components
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 120, height: 170)
        layout.minimumLineSpacing = Constants.spacings.md
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 0, left: Constants.spacings.xl, bottom: 0, right: 0)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
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
private extension DictHorizontalSectionTableViewCell {
    
    func setUp() {
        setUpConstraints()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DictHorizontalCollectionViewCell.self, forCellWithReuseIdentifier: DictHorizontalCollectionViewCell.identifier)
    }
    
    func setUpConstraints() {
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(170)
        }
    }
}

extension DictHorizontalSectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DictHorizontalCollectionViewCell.identifier, for: indexPath) as? DictHorizontalCollectionViewCell else { return UICollectionViewCell() }
        guard let datas = datas.value else { return UICollectionViewCell() }
        cell.bind(data: datas[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let datas = datas.value else { return }
        self.delegate?.didSelectItemAt(itemTitle: datas[indexPath.row].title, type: datas[indexPath.row].type)
    }
}

// MARK: - Bind
extension DictHorizontalSectionTableViewCell {
    
    func bind() {
        datas.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
    
    func bind(data: DictSectionDatas) {
        datas.value = data.datas
    }
}
