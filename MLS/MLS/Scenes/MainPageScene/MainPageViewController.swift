//
//  MainPageViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 1/14/24.
//

import Foundation
import UIKit
import SnapKit

class MainPageViewController: BasicController {
    // MARK: - Property
    private let viewModel: MainPageViewModel

    // MARK: - Components

    private let menuButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        let image = UIImage(systemName: "list.bullet", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .systemGray4
        return button
    }()
    
    private let featureCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.defaults.vertical
        layout.minimumInteritemSpacing = Constants.defaults.horizontal
        layout.sectionInset = .init(top: Constants.defaults.vertical, left: 0, bottom: 0, right: 0)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    private let sideMenuView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let sideMenuEmptyView: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray4
        button.isHidden = true
        button.alpha = 0
        return button
    }()
    
    private let sideMenuTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .systemOrange
        view.separatorStyle = .none
        return view
    }()
    
    init(viewModel: MainPageViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension MainPageViewController {
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .systemOrange
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.sideMenuTableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
}

private extension MainPageViewController {
    // MARK: - SetUp

    func setUp() {
        setUpConstraints()
        setUpDelegate()
        setUpAddTarget()
        setUpRegistor()
    }
    
    func setUpRegistor() {
        featureCollectionView.register(MainPageFeatureDefaultsCell.self, forCellWithReuseIdentifier: MainPageFeatureDefaultsCell.identifier)
        featureCollectionView.register(MainPageFeatureListCell.self, forCellWithReuseIdentifier: MainPageFeatureListCell.identifier)
        sideMenuTableView.register(MainPageProfileCell.self, forCellReuseIdentifier: MainPageProfileCell.identifier)
        sideMenuTableView.register(MainPageSideMenuFeatureCell.self, forCellReuseIdentifier: MainPageSideMenuFeatureCell.identifier)
    }
    
    func setUpDelegate() {
        featureCollectionView.delegate = self
        featureCollectionView.dataSource = self
        sideMenuTableView.dataSource = self
        sideMenuTableView.delegate = self
    }
    
    func setUpAddTarget() {
        menuButton.addTarget(self, action: #selector(didTapMenuButton), for: .primaryActionTriggered)
        sideMenuEmptyView.addTarget(self, action: #selector(didTapMenuEmptySpace), for: .primaryActionTriggered)
    }
    
    func setUpConstraints() {
        view.addSubview(menuButton)
        menuButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(Constants.defaults.horizontal)
            make.height.width.equalTo(Constants.defaults.blockHeight)
        }
        view.addSubview(featureCollectionView)
        featureCollectionView.snp.makeConstraints { make in
            make.top.equalTo(menuButton.snp.bottom).offset(Constants.defaults.vertical)
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        view.addSubview(sideMenuEmptyView)
        sideMenuEmptyView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        view.addSubview(sideMenuTableView)
        sideMenuTableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.right.equalTo(view.snp.left)
            make.width.equalTo(Constants.screenWidth * 0.7)
        }
    }
}

private extension MainPageViewController {
    // MARK: - Method

    @objc
    func didTapMenuButton() {
        switchMenuView(isOpen: true)
    }
    @objc
    func didTapMenuEmptySpace() {
        switchMenuView(isOpen: false)
    }
    
    func switchMenuView(isOpen: Bool) {
        sideMenuEmptyView.isHidden = !isOpen
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) { [weak self] in
            guard let self = self else { return }
            if isOpen {
                self.sideMenuEmptyView.alpha = 0.3
            } else {
                self.sideMenuEmptyView.alpha = 0
            }
            let value: CGFloat = isOpen ? Constants.screenWidth * 0.7 : -Constants.screenWidth * 0.7
            self.sideMenuTableView.transform = CGAffineTransform(
                translationX: self.sideMenuTableView.bounds.origin.x + value, y: self.sideMenuTableView.bounds.origin.y
            )
        }
    }
}

extension MainPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.features.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.features[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = featureCollectionView.dequeueReusableCell(
                withReuseIdentifier: MainPageFeatureDefaultsCell.identifier, for: indexPath
            ) as? MainPageFeatureDefaultsCell else {
                return UICollectionViewCell()
            }
            cell.bind(data: viewModel.features[indexPath.section][indexPath.row])
            return cell
        case 1:
            guard let cell = featureCollectionView.dequeueReusableCell(
                withReuseIdentifier: MainPageFeatureListCell.identifier, for: indexPath
            ) as? MainPageFeatureListCell else {
                return UICollectionViewCell()
            }
            switch indexPath.row {
            case 0:
                viewModel.getMainPost(type: .normal) { posts in
                    cell.posts.value = posts
                }
            default:
                viewModel.getMainPost(type: .complete) { posts in
                    cell.posts.value = posts
                }
            }
            cell.bind(data: viewModel.features[indexPath.section][indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        switch indexPath.section {
        case 0:
            return CGSize(width: Constants.screenWidth, height: Constants.defaults.blockHeight * 2)
        case 1:
            return CGSize(width: Constants.screenWidth, height: (Constants.defaults.blockHeight * 4) + (Constants.defaults.vertical * 3) )
        default:
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let title = viewModel.features[indexPath.section][indexPath.row].title
        if title == "도감" {
            let vc = DictionaryMainViewController(viewModel: DictionaryMainViewModel())
            self.navigationController?.pushViewController(vc, animated: true)
        } else if title == "최신글" {
            let vc = CommunityPageViewController(viewModel: CommunityPageViewModel(type: .normal))
            self.navigationController?.pushViewController(vc, animated: true)
        } else if title == "사고팔고" {
            let vc = CommunityPageViewController(viewModel: CommunityPageViewModel(type: .complete))
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension MainPageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getSideMenuItems()[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getSideMenuItems().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = sideMenuTableView.dequeueReusableCell(withIdentifier: MainPageProfileCell.identifier, for: indexPath) as? MainPageProfileCell else { return UITableViewCell() }
            if viewModel.loginManager.isLogin() {
                cell.bind(description: "temptemp")
            } else {
                cell.bind(description: "로그인")
            }
            return cell
        default:
            guard let cell = sideMenuTableView.dequeueReusableCell(withIdentifier: MainPageSideMenuFeatureCell.identifier, for: indexPath) as? MainPageSideMenuFeatureCell else { return UITableViewCell() }
            cell.bind(data: viewModel.getSideMenuItems()[indexPath.section][indexPath.row])
            if indexPath.row != viewModel.getSideMenuItems()[indexPath.section].count - 1 {
                cell.makeSeparator()
            } else {
                cell.removeSeparator()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let title = viewModel.getSideMenuItems()[indexPath.section][indexPath.row].title else { return }
        if title == "프로필" {
            if viewModel.loginManager.isLogin() {
                print("profilePage")
            } else {
                let vc = SignInViewController(viewModel: SignInViewModel())
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if title == "자유 게시판" {
            let vc = CommunityPageViewController(viewModel: CommunityPageViewModel(type: .normal))
            self.navigationController?.pushViewController(vc, animated: true)
        } else if title == "거래 게시판" {
            let vc = CommunityPageViewController(viewModel: CommunityPageViewModel(type: .normal))
            self.navigationController?.pushViewController(vc, animated: true)
        } else if title == "로그아웃" {
            AlertMaker.showAlertAction2(vc: self, title: "로그아웃",message: "정말로 로그아웃 하시겠습니까?", cancelTitle: "취소", completeTitle: "확인", nil, {
                let loginManger = LoginManager()
                IndicatorMaker.showLoading()
                loginManger.logOut { [weak self] isLogOut in
                    self?.sideMenuTableView.reloadData()
                    IndicatorMaker.hideLoading()
                }
            })
        } else if title == "문의하기" {
            let vc = QnaViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if title == "회원탈퇴" {
            print("회원탈퇴")
        } else if title == "시뮬레이터" {
            print("시뮬레이터")
        }
    }
    
}
