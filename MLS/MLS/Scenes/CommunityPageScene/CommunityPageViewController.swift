//
//  CommunityPageScene.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/14.
//

import UIKit

import SnapKit

class CommunityPageViewController: BasicController {
    // MARK: - Properties

    private let viewModel: CommunityPageViewModel

    private var sortItems: [UIAction] {
        let first = UIAction(title: "최신순", image: UIImage(systemName: ""), handler: { [weak self] _ in
            self?.viewModel.sortType.value = .new
        })

        let second = UIAction(title: "조회순", image: UIImage(systemName: ""), handler: { [weak self] _ in
            self?.viewModel.sortType.value = .popular
        })

        let Items = [first, second]

        return Items
    }

    // MARK: - Components

    lazy var menu = UIMenu(title: "게시물 정렬", children: sortItems)

    private let titleButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemOrange, for: .normal)
        button.titleLabel?.font = Typography.title1.font
        return button
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
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = Constants.defaults.radius
        button.showsMenuAsPrimaryAction = true
        return button
    }()

    private let communityTableView: UITableView = {
        let view = UITableView()
        return view
    }()

    private let addPostButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = Constants.defaults.blockHeight / 2
        button.tintColor = .white
        return button
    }()

    init(viewModel: CommunityPageViewModel) {
        self.viewModel = viewModel
        super.init()
        setUpPage(type: self.viewModel.type)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension CommunityPageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
        loadPosts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPosts()
    }
}

// MARK: - SetUp
private extension CommunityPageViewController {
    func setUp() {
        communityTableView.dataSource = self
        communityTableView.delegate = self

        communityTableView.register(CommunityTableViewCell.self, forCellReuseIdentifier: CommunityTableViewCell.identifier)
        communityTableView.register(SearchbarTableViewCell.self, forCellReuseIdentifier: SearchbarTableViewCell.identifier)

        setUpConstraints()
    }

    func setUpConstraints() {
        view.addSubview(titleButton)
        view.addSubview(searchButton)
        view.addSubview(sortButton)
        view.addSubview(communityTableView)
        view.addSubview(addPostButton)

        titleButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(Constants.defaults.vertical)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(Constants.defaults.horizontal)
        }

        sortButton.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(Constants.defaults.horizontal)
            $0.centerY.equalTo(titleButton)
            $0.width.equalTo(50)
            $0.height.equalTo(30)
        }

        searchButton.snp.makeConstraints {
            $0.trailing.equalTo(sortButton.snp.leading).offset(-Constants.defaults.horizontal)
            $0.centerY.equalTo(titleButton)
        }

        communityTableView.snp.makeConstraints {
            $0.top.equalTo(titleButton.snp.bottom).offset(Constants.defaults.vertical)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(Constants.defaults.vertical)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.defaults.horizontal)
        }
        addPostButton.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.defaults.blockHeight)
            make.right.equalTo(view.safeAreaLayoutGuide).inset(Constants.defaults.vertical * 2)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.defaults.horizontal)
        }
    }

    func setUpActions() {
        searchButton.addAction(UIAction(handler: { [weak self] _ in
            self?.addSearchBar()
        }), for: .touchUpInside)

        addPostButton.addAction(UIAction(handler: { [weak self] _ in
            guard let type = self?.viewModel.type,
                  let isLogin = self?.viewModel.isLogin() else { return }
            if isLogin {
                let vc = AddPostViewController(viewModel: AddPostViewModel(type: type))
                self?.navigationController?.pushViewController(vc, animated: true)
            } else {
                AlertMaker.showAlertAction1(vc: self, message: "로그인이 필요합니다.") {
                    let vc = SignInViewController(viewModel: SignInViewModel())
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }), for: .primaryActionTriggered)

        titleButton.addAction(UIAction(handler: { [weak self] _ in
            self?.loadPosts()
        }), for: .touchUpInside)
    }

    func setUpPage(type: BoardSeparatorType) {
        switch type {
        case .normal:
            titleButton.setTitle("자유게시판", for: .normal)
        case .sell, .buy, .complete:
            titleButton.setTitle("거래게시판", for: .normal)
        }
        setUpActions()
    }
}

// MARK: - Bind
private extension CommunityPageViewController {
    func bind() {
        viewModel.posts.bind { [weak self] _ in
            self?.communityTableView.reloadData()
        }

        viewModel.sortType.bind { [weak self] _ in
            self?.loadPosts()
        }
    }
}

// MARK: - Methods
private extension CommunityPageViewController {
    func loadPosts() {
        guard let sortType = viewModel.sortType.value else { return }
        IndicatorMaker.showLoading()
        viewModel.fetchPosts(sort: sortType) { posts in
            IndicatorMaker.hideLoading()
            self.viewModel.posts.value = posts
        }
    }

    func addSearchBar() {
        guard let posts = viewModel.posts.value else { return }
        let indexPath = IndexPath(row: posts.count, section: 0)
        if communityTableView.cellForRow(at: indexPath) == nil {
            viewModel.postsCount = viewModel.postsCount + 1
            communityTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        } else {
            viewModel.postsCount = viewModel.postsCount - 1
            communityTableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        }
    }
}

extension CommunityPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.postsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let postCell = tableView.dequeueReusableCell(withIdentifier: CommunityTableViewCell.identifier, for: indexPath) as? CommunityTableViewCell else { return UITableViewCell() }
        guard let searchCell = tableView.dequeueReusableCell(withIdentifier: SearchbarTableViewCell.identifier, for: indexPath) as? SearchbarTableViewCell else { return UITableViewCell() }
        if viewModel.posts.value?.count != viewModel.postsCount && indexPath.row == 0 {
            searchCell.searchBar.delegate = self
            searchCell.isUserInteractionEnabled = true
            searchCell.contentView.isUserInteractionEnabled = false
            return searchCell
        }
        guard let posts = viewModel.posts.value?[indexPath.row] else { return UITableViewCell() }
        postCell.bind(tag: posts.postType, title: posts.title, date: posts.date.toString(), upCount: String(posts.likes.count))
        return postCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let post = viewModel.posts.value?[indexPath.row] else { return }
        let viewController = PostDetailViewController(viewModel: PostDetailViewModel(post: post))
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension CommunityPageViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            viewModel.searchPosts(text: text) { [weak self] isExist in
                if !isExist {
                    AlertMaker.showAlertAction1(vc: self, message: "검색 결과가 없습니다.")
                }
            }
        } else {
            loadPosts()
        }
    }
}
