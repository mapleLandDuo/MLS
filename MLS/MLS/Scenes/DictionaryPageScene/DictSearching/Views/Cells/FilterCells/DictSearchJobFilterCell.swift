//
//  DictSearchJobFilterCell.swift
//  MLS
//
//  Created by SeoJunYoung on 2/28/24.
//

import UIKit

import SnapKit

class DictSearchJobFilterCell: UITableViewCell {
    
    
    // MARK: - Properties
    
    private let jobs = ["전사", "궁수", "도적", "법사"]

    
    // MARK: - Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_md, fontType: .bold)
        label.textColor = .semanticColor.text.primary
        label.addCharacterSpacing()
        label.text = "직업 선택"
        return label
    }()
    
    private let jobCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.spacings.md
        layout.sectionInset = .init(top: 0, left: Constants.spacings.xl, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        let width = (Constants.screenWidth - (Constants.spacings.xl * 2) - (Constants.spacings.md * 3)) / 4
        layout.itemSize = .init(width: width, height: 48)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
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

private extension DictSearchJobFilterCell {
    func setUp() {
        setUpConstraints()
        jobCollectionView.delegate = self
        jobCollectionView.dataSource = self
        jobCollectionView.register(DictSearchJobButtonCell.self, forCellWithReuseIdentifier: DictSearchJobButtonCell.identifier)
    }
    
    func setUpConstraints() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(jobCollectionView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(Constants.spacings.xl)
            $0.height.equalTo(Constants.spacings.xl)
        }
        
        jobCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.spacings.sm)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
            $0.bottom.equalToSuperview().inset(Constants.spacings.xl_2)
        }
    }
}

extension DictSearchJobFilterCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DictSearchJobButtonCell.identifier, for: indexPath) as? DictSearchJobButtonCell else { return  UICollectionViewCell() }
        cell.bind(job: jobs[indexPath.row])
        return cell
    }
}
