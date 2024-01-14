//
//  CommunityPageScene.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/14.
//

import UIKit

class CommunityPageViewController: UIViewController {
    // MARK: - Property

    private let viewModel: CommunityPageViewModel

    // MARK: - Components

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "자유게시판"
        return label
    }()

    let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: ""), for: .normal)
        return button
    }()

    let sortButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(showSortMenu))

    let communityTableView = UITableView()

    init(viewModel: CommunityPageViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
        navigationItem.rightBarButtonItem = sortButton
        communityTableView.dataSource = self
        communityTableView.delegate = self
        setUpConstraints()
    }
}

private extension CommunityPageViewController {
    // MARK: - Bind
}

private extension CommunityPageViewController {
    // MARK: - Method

    @objc func showSortMenu() {
        let sortMenu = UIMenu(title: "정렬", children: [
            UIAction(title: "조회순", handler: { _ in
                // 정렬
            }),
            UIAction(title: "최신순", handler: { _ in
                // 정렬
            })
        ])

        let menuController = UIMenuController.shared
        menuController.showMenu(from: view, rect: .zero)
        menuController.menuItems = sortMenu.children as? [UIMenuItem]
    }

    func setUpConstraints() {}
}

extension CommunityPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: communityTableViewCell.identifier)
        return cell
    }
    
    
}
