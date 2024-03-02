//
//  DictTagTableViewCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/02.
//

import UIKit

import SnapKit

class DictTagTableViewCell: UITableViewCell {
    // MARK: Properties
    private var items: [String]?

    // MARK: Components
    private let leadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .semanticColor.bg.primary
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let descriptionImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "info")
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .regular)
        label.textColor = .semanticColor.text.info_bold
        return label
    }()

    private let tagCollectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = Constants.spacings.md
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(DictTagCell.self, forCellWithReuseIdentifier: DictTagCell.identifier)
        view.backgroundColor = .clear
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
private extension DictTagTableViewCell {
    func setUp() {
        setUpConstraints()

        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
    }

    func setUpConstraints() {
        addSubview(leadingView)
        leadingView.addSubview(tagCollectionView)
        leadingView.addSubview(descriptionImageView)
        leadingView.addSubview(descriptionLabel)

        leadingView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Constants.spacings.lg)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
        }
        
        descriptionImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Constants.spacings.xl)
            $0.centerY.equalTo(descriptionLabel)
            $0.size.equalTo(16)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.leading.equalTo(descriptionImageView.snp.trailing).offset(Constants.spacings.xs)
            $0.height.equalTo(22)
        }

        tagCollectionView.snp.makeConstraints {
            $0.top.equalTo(descriptionImageView.snp.bottom).offset(Constants.spacings.lg)
            $0.leading.trailing.bottom.equalToSuperview().inset(Constants.spacings.xl)
            $0.height.equalTo(100)
        }
    }
}

// MARK: bind
extension DictTagTableViewCell {
    func bind(items: [String]?, descriptionType: DictType) {
        print(items)
        if let items = items {
            self.items = items
            tagCollectionView.reloadData()
            if items == [] {
                leadingView.isHidden = true
                // alert
            }
        } else {
            leadingView.isHidden = true
            // alert
        }
        
        switch descriptionType {
        case .map:
            descriptionLabel.text = "선택 시, 맵의 세부 정보를 볼 수 있어요."
        case .quest:
            descriptionLabel.text = "선택 시, 퀘스트의 세부 정보를 볼 수 있어요."
        default:
            break
        }
    }
}

extension DictTagTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = items?.count else { return 0 }
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DictTagCell.identifier, for: indexPath) as? DictTagCell,
              let item = items?[indexPath.row] else { return UICollectionViewCell() }
        cell.bind(item: item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DictTagCell.identifier, for: indexPath) as? DictTagCell else { return CGSize() }
        let targetSize = CGSize(width: collectionView.bounds.width, height: UIView.layoutFittingExpandedSize.height)
        let fittingSize = cell.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .fittingSizeLevel)

        return fittingSize
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }

        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return attributes
    }
}
