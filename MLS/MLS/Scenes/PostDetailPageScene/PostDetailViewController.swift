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

    // MARK: - Components

    private let totalTableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.sectionHeaderTopPadding = 0
        return view
    }()

    lazy var commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.triangle.turn.up.right.circle.fill")?.resized(to: CGSize(width: 40, height: 40)), for: .normal)
        button.tintColor = .gray
        button.isUserInteractionEnabled = self.viewModel.isLogin()
        return button
    }()

    lazy var commentTextField: SharedTextField = {
        let textField = SharedTextField(type: .normal, placeHolder: "댓글입력")
        textField.isUserInteractionEnabled = self.viewModel.isLogin()
        return textField
    }()

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
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let id = viewModel.post.value?.id {
            viewModel.loadComment(postId: id.uuidString)
        }
        totalTableView.reloadData()
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
        setUpNavigation()
    }

    func setUpConstraints() {
        view.addSubview(totalTableView)

        totalTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func setUpActions() {
        commentButton.addAction(UIAction(handler: { [weak self] _ in
            guard let post = self?.viewModel.post.value,
            let isEditing = self?.viewModel.isEditing else { return }
            if let text = self?.commentTextField.textField.text {
                if text == "" {
                    AlertMaker.showAlertAction1(vc: self, message: "댓글을 입력하세요.")
                    return
                }
                if isEditing {
                    guard let comment = self?.viewModel.editingComment else { return }
                    let newComment = Comment(
                        id: comment.id,
                        user: comment.user,
                        date: Date(),
                        likeCount: comment.likeCount,
                        comment: "\(text) (수정됨)",
                        report: comment.report,
                        state: comment.state)
                    self?.viewModel.updateComment(postId: post.id.uuidString, comment: newComment) {
                        self?.commentTextField.textField.text = ""
                        AlertMaker.showAlertAction1(vc: self, message: "댓글입력이 수정 되었습니다.")
                        if let id = self?.viewModel.post.value?.id {
                            self?.viewModel.loadComment(postId: id.uuidString)
                            self?.viewModel.isEditing = false
                        }
                    }
                } else {
                    guard let user = Utils.currentUser else { return }
                    let comment = Comment(
                        id: UUID(),
                        user: user,
                        date: Date(),
                        likeCount: [],
                        comment: text,
                        report: [],
                        state: true)
                    self?.viewModel.saveComment(postId: post.id.uuidString, comment: comment) {
                        self?.commentTextField.textField.text = ""
                        AlertMaker.showAlertAction1(vc: self, message: "댓글입력이 완료 되었습니다.")
                        if let id = self?.viewModel.post.value?.id {
                            self?.viewModel.loadComment(postId: id.uuidString)
                        }
                    }
                }
            } else {
                AlertMaker.showAlertAction1(vc: self, message: "댓글을 입력하세요.")
            }
        }), for: .touchUpInside)
    }

    func setUpNavigation() {
        let modifyMenu = UIAction(title: "수정", handler: { [weak self] _ in
            guard let type = self?.viewModel.post.value?.postType,
                  let post = self?.viewModel.post else { return }
            let vm = AddPostViewModel(type: type)
            vm.postData = post
            vm.isEditing = true
            let vc = AddPostViewController(viewModel: vm)
            self?.navigationController?.pushViewController(vc, animated: true)
        })

        let deleteMenu = UIAction(title: "삭제", attributes: .destructive, handler: { [weak self] _ in
            AlertMaker.showAlertAction2(vc: self, title: "정말 삭제하시겠습니까?", message: "영구적으로 삭제됩니다.", cancelTitle: "취소", completeTitle: "확인", {}, {
                guard let postId = self?.viewModel.post.value?.id else { return }
                self?.viewModel.deletPost(postId: postId.uuidString) {
                    self?.navigationController?.popViewController(animated: true)
                }
            })
        })

        let reportMenu = UIAction(title: "신고하기", attributes: .destructive, handler: { [weak self] _ in
            // 신고
        })

        let loginMenu = UIMenu(children: [modifyMenu, deleteMenu])
        let logoutMenu = UIMenu(children: [reportMenu])

        let navigationMenu = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: viewModel.isLogin() ? loginMenu : logoutMenu)

        navigationItem.rightBarButtonItem = navigationMenu
    }
}

private extension PostDetailViewController {
    // MARK: Bind

    func bind() {
        viewModel.comments.bind { [weak self] _ in
            self?.totalTableView.reloadSections(IndexSet(integer: 2), with: .automatic)
        }
    }
}

private extension PostDetailViewController {
    // MARK: Method
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
            cell.contentView.isUserInteractionEnabled = false
            cell.bind(post: post)
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailCommentCell.identifier, for: indexPath) as? DetailCommentCell,
                  let comment = viewModel.comments.value?[indexPath.row] else { return UITableViewCell() }
            cell.delegate = self
            cell.comment = comment
            cell.contentView.isUserInteractionEnabled = false
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
                $0.top.bottom.equalToSuperview().inset(Constants.defaults.horizontal / 2)
                $0.leading.equalToSuperview().inset(Constants.defaults.vertical)
            }

            commentButton.snp.makeConstraints {
                $0.top.trailing.bottom.equalToSuperview()
                $0.leading.equalTo(commentTextField.snp.trailing)
                $0.size.equalTo(50)
            }

            headerView.backgroundColor = .white

            return headerView
        }

        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 70
        }
        return 0
    }
}

extension PostDetailViewController: DetailCommentCellDelegate {
    func tapDeleteButton(cell: DetailCommentCell, comment: Comment) {
        guard let postId = viewModel.post.value?.id.uuidString else { return }
        AlertMaker.showAlertAction2(vc: self, title: "정말 삭제하시겠습니까?", message: "영구적으로 삭제됩니다.", cancelTitle: "취소", completeTitle: "확인", {}, {
            self.viewModel.deleteComment(postId: postId, commentId: comment.id.uuidString) {
                self.viewModel.loadComment(postId: postId)
            }
        })
    }

    func tapModifyButton(cell: DetailCommentCell, comment: Comment) {
        self.commentTextField.textField.text = comment.comment
        viewModel.isEditing = true
        viewModel.editingComment = comment
    }
}
