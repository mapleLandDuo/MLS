//
//  DictHorizontalSectionTableViewCell.swift
//  MLS
//
//  Created by SeoJunYoung on 2/19/24.
//

import UIKit

import SnapKit

import RxSwift
import RxCocoa

protocol DictHorizontalSectionTableViewCellDelegate: BasicController {
    func didSelectItemAt(itemTitle: String, type: DictType)
}

class DictHorizontalSectionTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    private var disposeBag = DisposeBag()
    
    private var datas = BehaviorRelay<[DictSectionData]>(value: [])

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
        setUpBind()
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
        collectionView.register(DictHorizontalCollectionViewCell.self, forCellWithReuseIdentifier: DictHorizontalCollectionViewCell.identifier)
    }
    
    func setUpConstraints() {
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(170)
        }
    }
    
    func setUpBind() {
        datas.bind(to: collectionView.rx.items(cellIdentifier: DictHorizontalCollectionViewCell.identifier)) 
            { (index: Int, element: DictSectionData, cell: DictHorizontalCollectionViewCell) in
                cell.bind(data: element)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe { (owner, indexPath) in
                let datas = owner.datas.value
                owner.delegate?.didSelectItemAt(itemTitle: datas[indexPath.row].title, type: datas[indexPath.row].type)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Bind
extension DictHorizontalSectionTableViewCell {
    
    func bind(data: DictSectionDatas) {
        datas.accept(data.datas)
    }
}
