//
//  MainPageFeatureListCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/14/24.
//

import SnapKit
import UIKit

class MainPageFeatureListCell: UICollectionViewCell {
    // MARK: - Property

    var posts: Observable<[Post]> = Observable(nil)

    // MARK: - Components

    private let trailingView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = Constants.defaults.radius
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemOrange.cgColor
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title1.font
        label.textColor = .systemOrange
        return label
    }()

    private let rightImageView: UIImageView = {
        let view = UIImageView()
        view.tintColor = .systemOrange
        return view
    }()

    private let postListTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.layer.cornerRadius = Constants.defaults.radius
        view.separatorStyle = .none
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        postsBind()
        titleLabel.startTextFlowAnimation(superViewWidth: Constants.screenWidth - (Constants.defaults.horizontal * 4))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MainPageFeatureListCell {
    // MARK: - SetUp

    func setUp() {
        setUpConstraints()
        postListTableView.dataSource = self
        postListTableView.register(MainPageFeatureListPostCell.self, forCellReuseIdentifier: MainPageFeatureListPostCell.identifier)
    }

    func setUpConstraints() {
        contentView.addSubview(trailingView)
        trailingView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.top.bottom.equalToSuperview()
        }
        trailingView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.right.left.equalToSuperview().inset(Constants.defaults.horizontal)
            make.top.equalToSuperview().inset(Constants.defaults.vertical)
            make.height.equalTo(Constants.defaults.blockHeight)
        }
        trailingView.addSubview(rightImageView)
        rightImageView.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.defaults.blockHeight / 2)
            make.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.centerY.equalTo(titleLabel)
        }
        trailingView.addSubview(postListTableView)
        postListTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.bottom.equalToSuperview().inset(Constants.defaults.vertical)
        }
    }
}

extension MainPageFeatureListCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = posts.value?.count else { return 0 }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = postListTableView.dequeueReusableCell(
            withIdentifier: MainPageFeatureListPostCell.identifier, for: indexPath
        ) as? MainPageFeatureListPostCell,
              let item = posts.value?[indexPath.row]
        else {
            return UITableViewCell()
        }
        cell.bind(text: item.title)
        return cell
    }
}

extension MainPageFeatureListCell {
    func bind(data: FeatureCellData) {
        titleLabel.text = data.title
        rightImageView.image = data.image
    }
    
    func postsBind() {
        posts.bind { [weak self] _ in
            self?.postListTableView.reloadData()
        }
    }
}
