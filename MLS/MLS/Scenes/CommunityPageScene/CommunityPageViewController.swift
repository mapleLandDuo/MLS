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

    private let viewModel: CommunityPageViewModel
    private var posts: [Post]?
    lazy var numOfposts = self.posts?.count
    private var type = BoardSeparatorType.normal
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

    private let titleLabel = CustomLabel(text: "title", textColor: .systemOrange, font: .boldSystemFont(ofSize: 30))

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
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = Constants.defaults.radius
        button.showsMenuAsPrimaryAction = true
        return button
    }()

    let communityTableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        return view
    }()

    init(viewModel: CommunityPageViewModel, type: BoardSeparatorType) {
        self.viewModel = viewModel
        super.init()
        self.type = type
        setUpPage(type: self.type)
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
        communityTableView.dataSource = self
        communityTableView.delegate = self
        communityTableView.register(CommunityTableViewCell.self, forCellReuseIdentifier: CommunityTableViewCell.identifier)
        communityTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)

        setUpConstraints()
        posts = viewModel.getPost()
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
            $0.width.equalTo(50)
            $0.height.equalTo(30)
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

    func setUpActions() {
        searchButton.addAction(UIAction(handler: { [weak self] _ in
            self?.addSearchBar()
        }), for: .touchUpInside)
    }

    func setUpPage(type: BoardSeparatorType) {
        switch type {
        case .normal:
            titleLabel.text = "자유게시판"
        // 정렬 속성
        case .sell, .buy, .complete:
            titleLabel.text = "거래게시판"
            // 정렬 속성
        }
        setUpActions()
    }

    func addSearchBar() {
        guard let numOfposts = numOfposts else { return }
        guard let posts = posts else { return }
        let indexPath = IndexPath(row: posts.count, section: 0)
        if communityTableView.cellForRow(at: indexPath) == nil {
            self.numOfposts = numOfposts + 1
            communityTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        } else {
            self.numOfposts = numOfposts - 1
            communityTableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        }
    }
}

extension CommunityPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numOfposts = numOfposts else { return 0 }
        return numOfposts
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let postCell = tableView.dequeueReusableCell(withIdentifier: CommunityTableViewCell.identifier, for: indexPath) as? CommunityTableViewCell else { return UITableViewCell() }
        guard let searchCell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        guard let posts = posts?[indexPath.row] else { return UITableViewCell() }
        if self.posts?.count != numOfposts && indexPath.row == 0 {
            searchCell.searchBar.delegate = self
            searchCell.isUserInteractionEnabled = true
            searchCell.contentView.isUserInteractionEnabled = false
            return searchCell
        }
        postCell.bind(tag: type, title: posts.title, date: posts.date.toString(), upCount: String(posts.upCount))
        return postCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}

extension CommunityPageViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {}

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {}

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
}
