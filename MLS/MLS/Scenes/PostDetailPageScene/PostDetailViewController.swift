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

    let dummy = [URL(string: "https://blog.kakaocdn.net/dn/lOszd/btrOBLArMVV/rdorYnmzpEFKJPjTgl41n0/img.png"), URL(string: "https://blog.kakaocdn.net/dn/lOszd/btrOBLArMVV/rdorYnmzpEFKJPjTgl41n0/img.png")]

    // MARK: - Components

    private let verticalScrollView = UIScrollView()

    private let verticalContentView = UIView()

    private let imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        view.backgroundColor = .black
        return view
    }()
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

        verticalContentView.snp.remakeConstraints {
            $0.edges.equalTo(verticalScrollView)
            $0.width.equalTo(verticalScrollView)
            $0.height.equalTo(safeAreaHeight + postDetailViewHeight + Constants.defaults.vertical)
        }
    }
}

private extension PostDetailViewController {
    // MARK: - SetUp

    func setUp() {
        navigationController?.isNavigationBarHidden = true

        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)

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
        verticalContentView.addSubview(postDetailView)

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

        postDetailView.snp.makeConstraints {
            $0.top.equalTo(imageCollectionView.snp.bottom).inset(-Constants.defaults.vertical)
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
