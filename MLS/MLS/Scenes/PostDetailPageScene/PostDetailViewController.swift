//
//  PostDetailViewController.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/16.
//

import UIKit

import SnapKit

class PostDetailViewController: BasicController {
    // MARK: - Properties

    private let viewModel: PostDetailViewModel

    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    lazy var safeAreaInsets = self.windowScene?.windows.first?.safeAreaInsets
    lazy var safeAreaHeight = UIScreen.main.bounds.height - self.safeAreaInsets!.top - self.safeAreaInsets!.bottom

//    let dummy = [URL(string: "https://www.mancity.com/meta/media/kppnc3ji/team-lifting-trophy.png"), URL(string: "https://blog.kakaocdn.net/dn/lOszd/btrOBLArMVV/rdorYnmzpEFKJPjTgl41n0/img.png")]

    // MARK: - Components

    private let totalTableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.sectionHeaderTopPadding = 0
        return view
    }()
    
    let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.triangle.turn.up.right.circle.fill")?.resized(to: CGSize(width: 40, height: 40)), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    let commentTextField = SharedTextField(type: .normal, placeHolder: "댓글입력")

    init(viewModel: PostDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostDetailViewController {
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getComment()
    }
}

private extension PostDetailViewController {
    // MARK: - SetUp

    func setUp() {
        totalTableView.delegate = self
        totalTableView.dataSource = self

        totalTableView.register(DetailImageCell.self, forCellReuseIdentifier: DetailImageCell.identifier)
        totalTableView.register(DetailPostCell.self, forCellReuseIdentifier: DetailPostCell.identifier)
        totalTableView.register(DetailCommentCell.self, forCellReuseIdentifier: DetailCommentCell.identifier)

        setUpConstraints()
        setUpActions()
    }

    func setUpConstraints() {
        view.addSubview(totalTableView)

        totalTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setUpActions() {
        commentButton.addAction(UIAction(handler: { [weak self] _ in
            guard let post = self?.viewModel.post.value else { return }
            if let text = self?.commentTextField.textField.text {
                let comment = Comment(
                    id: UUID(),
                    user: post.user,
                    date: Date(),
                    likeCount: [],
                    comment: text,
                    report: [],
                    state: true)
                self?.viewModel.saveComment(postId: post.id.uuidString, comment: comment)
                self?.viewModel.comments.value?.insert(comment, at: 0)
                self?.commentTextField.textField.text = ""
                AlertMaker.showAlertAction1(vc: self, message: "댓글입력이 완료 되었습니다.")
            } else {
                AlertMaker.showAlertAction1(vc: self, message: "댓글을 입력하세요.")
            }
        }), for: .touchUpInside)
    }
}

private extension PostDetailViewController {
    // MARK: Bind
    func bind() {
        viewModel.comments.bind { [weak self] _ in
            self?.totalTableView.reloadData()
        }
    }
}

private extension PostDetailViewController {
    // MARK: Method
    func getComment() {
        guard let id = viewModel.post.value?.id.uuidString else { return }
        self.viewModel.loadComment(postId: id) {
            self.totalTableView.reloadData()
        }
    }
}

extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if let count = viewModel.post.value?.postImages.count {
                return count
            }
            return 0
        case 1:
            return 1
        case 2:
            return viewModel.commentCount
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailImageCell.identifier, for: indexPath) as? DetailImageCell else { return UITableViewCell() }
            cell.bind(images: viewModel.post.value?.postImages)
            cell.contentView.isUserInteractionEnabled = false
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailPostCell.identifier, for: indexPath) as? DetailPostCell,
                  let post = viewModel.post.value else { return UITableViewCell() }
            cell.bind(post: post)
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailCommentCell.identifier, for: indexPath) as? DetailCommentCell,
                  let comment = viewModel.comments.value?[indexPath.row] else { return UITableViewCell() }
            print(comment)
            cell.bind(comment: comment)
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return safeAreaHeight
        case 1:
            return 500
        case 2:
            return 70
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            let headerView = UIView()

            headerView.addSubview(commentTextField)
            headerView.addSubview(commentButton)

            commentTextField.snp.makeConstraints {
                $0.top.leading.bottom.equalToSuperview()
            }

            commentButton.snp.makeConstraints {
                $0.top.trailing.bottom.equalToSuperview()
                $0.leading.equalTo(commentTextField.snp.trailing)
            }

            headerView.backgroundColor = .white

            return headerView
        }

        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 60
        }
        return 0
    }
}
