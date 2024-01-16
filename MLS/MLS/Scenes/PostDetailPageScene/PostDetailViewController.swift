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

    let postDetailView = PostDetailView()

    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    lazy var safeAreaInsets = self.windowScene?.windows.first?.safeAreaInsets
    lazy var safeAreaHeight = UIScreen.main.bounds.height - self.safeAreaInsets!.top - self.safeAreaInsets!.bottom

    let dummy = [URL(string: "https://www.mancity.com/meta/media/kppnc3ji/team-lifting-trophy.png"), URL(string: "https://blog.kakaocdn.net/dn/lOszd/btrOBLArMVV/rdorYnmzpEFKJPjTgl41n0/img.png")]

    // MARK: - Components

    private let verticalScrollView = UIScrollView()

    private let verticalContentView = UIView()

    private let imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        view.backgroundColor = .black
        view.isPagingEnabled = true
        return view
    }()

    private let handleIamgeView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "pullIcon")?.resized(to: CGSize(width: 20, height: 16))
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = Constants.defaults.radius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.contentMode = .scaleAspectFit
        return view
    }()

    lazy var addCommentStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [commentProfileImageView, commentTextView, commentButton])
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = 10
        return view
    }()

    private let commentProfileImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "photo")?.resized(to: CGSize(width: 40, height: 40))
        view.clipsToBounds = true
        view.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        view.layer.cornerRadius = view.frame.height / 2
        return view
    }()

    private let commentTextView: UITextField = {
        let textField = UITextField()
        textField.placeholder = " 댓글 입력"
        textField.backgroundColor = .systemGray4
        textField.layer.cornerRadius = Constants.defaults.radius
        return textField
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.triangle.turn.up.right.circle.fill")?.resized(to: CGSize(width: 40, height: 40)), for: .normal)
        button.tintColor = .gray
        return button
    }()

    private let commentTableView = UITableView()
}

extension PostDetailViewController {
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let postDetailViewHeight = postDetailView.frame.height
        let commentStackViewHeight = addCommentStackView.frame.height

        verticalContentView.snp.remakeConstraints {
            $0.edges.equalTo(verticalScrollView)
            $0.width.equalTo(verticalScrollView)
            $0.height.equalTo(safeAreaHeight + postDetailViewHeight + commentStackViewHeight + Constants.defaults.vertical * 2)
        }
    }
}

private extension PostDetailViewController {
    // MARK: - SetUp

    func setUp() {
        navigationController?.isNavigationBarHidden = true

        verticalScrollView.delegate = self

        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.register(<#T##nib: UINib?##UINib?#>, forCellReuseIdentifier: <#T##String#>)

        setUpConstraints()
    }
}

private extension PostDetailViewController {
    // MARK: - Bind
}

private extension PostDetailViewController {
    // MARK: - Method

    func setUpConstraints() {
        view.addSubview(verticalScrollView)
        verticalScrollView.addSubview(verticalContentView)
        verticalContentView.addSubview(imageCollectionView)
        verticalContentView.addSubview(handleIamgeView)
        verticalContentView.addSubview(postDetailView)
        verticalContentView.addSubview(addCommentStackView)

        verticalScrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

        verticalContentView.snp.makeConstraints {
            $0.edges.equalTo(verticalScrollView)
            $0.width.equalTo(verticalScrollView)
            $0.height.equalTo(safeAreaHeight)
        }

        imageCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(verticalContentView)
            $0.height.equalTo(safeAreaHeight)
        }

        handleIamgeView.snp.makeConstraints {
            $0.bottom.equalTo(imageCollectionView)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(30)
        }

        postDetailView.snp.makeConstraints {
            $0.top.equalTo(imageCollectionView.snp.bottom).inset(-Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        
        addCommentStackView.snp.makeConstraints {
            $0.top.equalTo(postDetailView.snp.bottom).inset(-Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        
        commentProfileImageView.snp.makeConstraints {
            $0.size.equalTo(40)
        }
        
        commentButton.snp.makeConstraints {
            $0.size.equalTo(40)
        }
        
        commentTableView.snp.makeConstraints {
            $0.top.equalTo(addCommentStackView.snp.bottom).inset(-Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }
    }
}

extension PostDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        guard let item = dummy[indexPath.row] else { return UICollectionViewCell() }
        cell.bind(imageUrl: item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension PostDetailViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.handleIamgeView.isHidden = true
        }
    }
}
