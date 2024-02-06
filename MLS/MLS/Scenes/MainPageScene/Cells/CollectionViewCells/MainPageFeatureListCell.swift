//
//  MainPageFeatureListCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/14/24.
//

import UIKit

import SnapKit

class MainPageFeatureListCell: UICollectionViewCell {
    // MARK: - Properties

    var posts: Observable<[Post]> = Observable(nil)

    var parent: BasicController = .init()

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

    private let titleSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
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

// MARK: - SetUp
private extension MainPageFeatureListCell {

    func setUp() {
        setUpConstraints()
        postListTableView.dataSource = self
        postListTableView.delegate = self
        postListTableView.register(MainPageFeatureListPostCell.self, forCellReuseIdentifier: MainPageFeatureListPostCell.identifier)
        postListTableView.register(DictionaryGraySeparatorOneLineCell.self, forCellReuseIdentifier: DictionaryGraySeparatorOneLineCell.identifier)
    }

    func setUpConstraints() {
        contentView.addSubview(trailingView)
        trailingView.addSubview(titleLabel)
        trailingView.addSubview(rightImageView)
        trailingView.addSubview(titleSeparator)
        trailingView.addSubview(postListTableView)
        
        trailingView.snp.makeConstraints { 
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.top.bottom.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { 
            $0.trailing.leading.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.top.equalToSuperview().inset(Constants.defaults.vertical)
            $0.height.equalTo(Constants.defaults.blockHeight)
        }

        rightImageView.snp.makeConstraints { 
            $0.width.height.equalTo(Constants.defaults.blockHeight / 2)
            $0.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.centerY.equalTo(titleLabel)
        }

        titleSeparator.snp.makeConstraints { 
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.height.equalTo(1)
        }

        postListTableView.snp.makeConstraints { 
            $0.top.equalTo(titleSeparator.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(Constants.defaults.vertical)
        }
    }
}

// MARK: - Bind
extension MainPageFeatureListCell {
    func bind(data: FeatureCellData, vc: BasicController) {
        titleLabel.text = data.title
        rightImageView.image = data.image
        parent = vc
    }

    func postsBind() {
        posts.bind { [weak self] _ in
            self?.postListTableView.reloadData()
        }
    }
}

extension MainPageFeatureListCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = posts.value?.count else { return 0 }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = postListTableView.dequeueReusableCell(
            withIdentifier: DictionaryGraySeparatorOneLineCell.identifier, for: indexPath
        ) as? DictionaryGraySeparatorOneLineCell,
            let item = posts.value?[indexPath.row]
        else {
            return UITableViewCell()
        }
        cell.bind(name: item.title, description: "")
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = posts.value?[indexPath.row] else { return }
        let vc = PostDetailViewController(viewModel: PostDetailViewModel(post: item))
        parent.navigationController?.pushViewController(vc, animated: true)
    }
}


