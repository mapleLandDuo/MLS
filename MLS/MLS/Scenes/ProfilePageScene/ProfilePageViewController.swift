//
//  ProfilePageViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 1/30/24.
//

import UIKit

import SnapKit

class ProfilePageViewController: BasicController {
    // MARK: - Property

    private let viewModel: ProfilePageViewModel

    // MARK: - Components

    lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.nickName
        label.font = Typography.title1.font
        return label
    }()

    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = self.viewModel.getPrivateEmail()
        label.textColor = .systemGray4
        label.font = Typography.title3.font
        return label
    }()

    private let nickNameSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        return view
    }()

    private let writtenPostLabel: UILabel = {
        let label = UILabel()
        label.text = "작성한 게시글"
        label.font = Typography.title2.font
        return label
    }()

    private let writtenSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()

    private let postTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        return view
    }()

    init(viewModel: ProfilePageViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfilePageViewController {
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        IndicatorMaker.showLoading()
        viewModel.loadPosts {
            IndicatorMaker.hideLoading()
        }
    }
}

private extension ProfilePageViewController {
    // MARK: - SetUp

    func setUp() {
        setUpConstraints()
        setUpNavigation()
        postTableView.delegate = self
        postTableView.dataSource = self
        postTableView.register(CommunityTableViewCell.self, forCellReuseIdentifier: CommunityTableViewCell.identifier)
    }

    func setUpConstraints() {
        view.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.bottom.equalTo(nickNameLabel.snp.bottom)
            make.left.equalTo(nickNameLabel.snp.right).offset(Constants.defaults.horizontal)
        }
        view.addSubview(nickNameSeparator)
        nickNameSeparator.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(Constants.defaults.horizontal)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.height.equalTo(1)
        }
        view.addSubview(writtenPostLabel)
        writtenPostLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameSeparator.snp.bottom).offset(Constants.defaults.vertical)
            make.left.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        view.addSubview(writtenSeparator)
        writtenSeparator.snp.makeConstraints { make in
            make.top.equalTo(writtenPostLabel.snp.bottom).offset(Constants.defaults.horizontal)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.height.equalTo(1)
        }
        view.addSubview(postTableView)
        postTableView.snp.makeConstraints { make in
            make.top.equalTo(writtenSeparator.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func setUpNavigation() {
        let deleteMenu = UIAction(title: "프로필 수정", handler: { [weak self] _ in
            AlertMaker.showAlertAction1(title: "업데이트 예정 기능입니다.")
        })

        let reportMenu = UIAction(title: "신고하기", attributes: .destructive, handler: { [weak self] _ in
            AlertMaker.showAlertAction2(vc: self, title: "정말 신고하시겠습니까?", message: "신고는 취소할 수 없습니다.", cancelTitle: "취소", completeTitle: "확인", {}, {
                guard let email = self?.viewModel.getProfileEmail() else { return }
                FirebaseManager.firebaseManager.reportUser(userID: email) {
                    self?.navigationController?.popViewController(animated: true)
                }
            })
        })

        let loginMenu = UIMenu(children: [deleteMenu])
        let logoutMenu = UIMenu(children: [reportMenu])

        let navigationMenu = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: viewModel.isMyProfile() ? loginMenu : logoutMenu)

        navigationItem.rightBarButtonItem = navigationMenu
    }
}

private extension ProfilePageViewController {
    // MARK: - Bind

    func bind() {
        viewModel.posts.bind { [weak self] _ in
            self?.postTableView.reloadData()
        }
    }
}

extension ProfilePageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = viewModel.posts.value?.count else { return 0 }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let datas = viewModel.posts.value else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommunityTableViewCell.identifier, for: indexPath) as? CommunityTableViewCell else { return UITableViewCell() }
        cell.bind(tag: datas[indexPath.row].postType,
                  title: datas[indexPath.row].title,
                  date: datas[indexPath.row].date.toString(),
                  upCount: String(datas[indexPath.row].likes.count))
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let posts = viewModel.posts.value else { return }
        let vc = PostDetailViewController(viewModel: PostDetailViewModel(post: posts[indexPath.row]))
        navigationController?.pushViewController(vc, animated: true)
    }
}
