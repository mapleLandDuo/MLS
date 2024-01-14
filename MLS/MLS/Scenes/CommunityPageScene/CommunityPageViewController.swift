//
//  CommunityPageScene.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/14.
//

import UIKit

import SnapKit

class CommunityPageViewController: BasicController {
    // MARK: - Property

//    private let viewModel: CommunityPageViewModel
    private var sortItems: [UIAction] {
        let first = UIAction(title: "최신순", image: UIImage(systemName: ""), handler: { [weak self] _ in
            // 정렬
        })

        let second = UIAction(title: "조회순", image: UIImage(systemName: ""), handler: { [weak self] _ in
            // 정렬
        })

        let Items = [first, second]

        return Items
    }

    lazy var menu = UIMenu(title: "게시물 정렬", children: sortItems)

    // MARK: - Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "자유게시판"
        return label
    }()

    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black
        return button
    }()

    lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setTitle("정렬", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.menu = self.menu
        button.showsMenuAsPrimaryAction = true
        return button
    }()

    let communityTableView = UITableView()

//    init(viewModel: CommunityPageViewModel) {
//        self.viewModel = viewModel
//        super.init()
//    }
//
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}

extension CommunityPageViewController {
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }
}

private extension CommunityPageViewController {
    // MARK: - SetUp

    func setUp() {
        communityTableView.dataSource = self
        communityTableView.delegate = self
        communityTableView.register(CommunityTableViewCell.self, forCellReuseIdentifier: CommunityTableViewCell.identifier)
        setUpConstraints()
    }
}

private extension CommunityPageViewController {
    // MARK: - Bind
}

private extension CommunityPageViewController {
    // MARK: - Method

    func setUpConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(searchButton)
        view.addSubview(sortButton)
        view.addSubview(communityTableView)

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(Constants.defaults.vertical)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(Constants.defaults.horizontal)
        }

        sortButton.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(Constants.defaults.horizontal)
            $0.centerY.equalTo(titleLabel)
        }

        searchButton.snp.makeConstraints {
            $0.trailing.equalTo(sortButton.snp.leading).inset(-Constants.defaults.horizontal)
            $0.centerY.equalTo(titleLabel)
        }

        communityTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(-Constants.defaults.vertical)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Constants.defaults.vertical)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.defaults.horizontal)
        }
    }
}

extension CommunityPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: CommunityTableViewCell.identifier)
        return cell
    }
}
