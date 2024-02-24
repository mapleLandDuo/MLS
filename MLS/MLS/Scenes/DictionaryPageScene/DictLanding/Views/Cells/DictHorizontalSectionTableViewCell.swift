//
//  DictHorizontalSectionTableViewCell.swift
//  MLS
//
//  Created by SeoJunYoung on 2/19/24.
//

import UIKit

import SnapKit

protocol DictHorizontalSectionTableViewCellDelegate: BasicController {
    func didTapCellButton(sectionTitle: String?)
    func didSelectItemAt(itemTitle: String?, type: DictType)
}

class DictHorizontalSectionTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    private var datas: Observable<[DictSectionData]> = Observable([])

    weak var delegate: DictHorizontalSectionTableViewCellDelegate?
    
    // MARK: - Components
    
    private let headerStackView: UIStackView = {
        let view = UIStackView()
        return view
    }()
    
    private let headerLeftStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = Constants.spacings.xs
        return view
    }()
    
    private let headerImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_md, fontType: .bold)
        label.textColor = .semanticColor.text.primary
        return label
    }()
    
    private let headerButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체보기", for: .normal)
        button.setTitleColor(.semanticColor.text.secondary, for: .normal)
        button.titleLabel?.addCharacterSpacing()
        button.titleLabel?.font = .customFont(fontSize: .body_sm, fontType: .medium)
        return button
    }()
    
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
        
        headerLeftStackView.addArrangedSubview(headerImageView)
        headerLeftStackView.addArrangedSubview(headerLabel)
        headerStackView.addArrangedSubview(headerLeftStackView)
        headerStackView.addArrangedSubview(headerButton)
        contentView.addSubview(headerStackView)
        contentView.addSubview(collectionView)
        
        headerStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.height.equalTo(24)
        }
        
        headerImageView.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(headerStackView.snp.bottom).offset(Constants.spacings.lg)
            $0.height.equalTo(170)
            $0.leading.trailing.bottom.equalToSuperview()
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
        headerImageView.image = data.iconImage
        headerLabel.text = data.description
        datas.value = data.datas
        headerButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.didTapCellButton(sectionTitle: data.description)
        }), for: .primaryActionTriggered)
    }
}
