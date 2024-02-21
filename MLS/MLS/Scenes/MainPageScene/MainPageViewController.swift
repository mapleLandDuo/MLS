//
//  MainPageViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 1/14/24.
//

import UIKit

import SnapKit
import SafariServices

class MainPageViewController: BasicController {
    // MARK: - Properties

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
    
    private let featureCollectionView: UICollectionView = {
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
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - LifeCycle
extension MainPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .systemOrange
        setUp()

//        let db = DatabaseUpdateManager()
//        db.readyToJson(fileName: .items) {
//            db.fetchJson(type: DictItem.self)
//        }
//        db.readyToJson(fileName: .monsters) {
//            db.fetchJson(type: DictMonster.self)
//        }
//        db.readyToJson(fileName: .maps) {
//            db.fetchJson(type: DictMap.self)
//        }
//        db.readyToJson(fileName: .npcs) {
//            db.fetchJson(type: DictNPC.self)
//        }
//        db.readyToJson(fileName: .quests) {
//            db.fetchJson(type: DictQuest.self)
//        }
//        let db1 = DatabaseUpdateManager()
//        db1.fetchJson(fileName: .items)
//        db1.fetchJson(fileName: .monsters)
        
//        let db = SqliteManager()
//        db.fetchTables()

//        db.filterItem(divisionName: nil ,rollName: "전사", minLv: nil, maxLv: nil) { items in
//            print("filter items", items)
//        }
//        
//        db.filterMonster(minLv: 60, maxLv: 100) { items in
//            print("filter monsters", items.map { $0.defaultValues })
//        }
//        
//        db.sortItem(field: .defaultValues, sortMenu: .EXP, order: .ASC) { (monsters: [DictMonster]) in
//            print("sort monsters", monsters.map { $0.defaultValues })
//        }
//
//        db.searchData(dataName: "가고일") { (monster: [DictMonster]) in
//            print("search monster", monster)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        sideMenuTableView.reloadData()
        featureCollectionView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
}

// MARK: - SetUp
private extension MainPageViewController {

    func setUp() {
        setUpConstraints()
        setUpDelegate()
        setUpAddAction()
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
    
    func setUpAddAction() {
        menuButton.addAction(UIAction(handler: { [weak self] _  in
            self?.didTapMenuButton()
        }), for: .primaryActionTriggered)
        sideMenuEmptyView.addAction(UIAction(handler: { [weak self] _ in
            self?.didTapMenuEmptySpace()
        }), for: .primaryActionTriggered)
    }
    
    func setUpConstraints() {
        
        view.addSubview(menuButton)
        view.addSubview(featureCollectionView)
        view.addSubview(sideMenuEmptyView)
        view.addSubview(sideMenuTableView)
        
        menuButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(Constants.defaults.horizontal)
            $0.height.width.equalTo(Constants.defaults.blockHeight)
        }
        featureCollectionView.snp.makeConstraints {
            $0.top.equalTo(menuButton.snp.bottom).offset(Constants.defaults.vertical)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        sideMenuEmptyView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        sideMenuTableView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.snp.leading)
            $0.width.equalTo(Constants.screenWidth * 0.7)
        }
    }
}

private extension MainPageViewController {
    // MARK: - Method

    func didTapMenuButton() {
        switchMenuView(isOpen: true)
    }

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
                IndicatorMaker.showLoading()
                viewModel.fetchMainPost(type: .normal) { posts in
                    cell.posts.value = posts
                    IndicatorMaker.hideLoading()
                }
            default:
                IndicatorMaker.showLoading()
                viewModel.fetchMainPost(type: .complete) { posts in
                    cell.posts.value = posts
                    IndicatorMaker.hideLoading()
                }
            }
            cell.bind(data: viewModel.features[indexPath.section][indexPath.row], vc: self)
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
            return CGSize(width: Constants.screenWidth, height: (Constants.defaults.blockHeight * 4) + (Constants.defaults.vertical))
        default:
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let title = viewModel.features[indexPath.section][indexPath.row].title
        if title == "도감" {
            let vc = DictionaryMainViewController(viewModel: DictionaryMainViewModel())
            navigationController?.pushViewController(vc, animated: true)
        } else if title == "최신글" {
            let vc = CommunityPageViewController(viewModel: CommunityPageViewModel(type: .normal))
            navigationController?.pushViewController(vc, animated: true)
        } else if title == "사고팔고" {
            let vc = CommunityPageViewController(viewModel: CommunityPageViewModel(type: .sell))
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MainPageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchSideMenuItems()[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.fetchSideMenuItems().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = sideMenuTableView.dequeueReusableCell(withIdentifier: MainPageProfileCell.identifier, for: indexPath) as? MainPageProfileCell else { return UITableViewCell() }
            if LoginManager.manager.isLogin() {
                IndicatorMaker.showLoading()
                guard let email = LoginManager.manager.email else { return UITableViewCell() }
                FirebaseManager.firebaseManager.fetchNickname(userEmail: email) { nickName in
                    IndicatorMaker.hideLoading()
                    cell.bind(description: nickName)
                }
            } else {
                cell.bind(description: "로그인")
            }
            return cell
        default:
            guard let cell = sideMenuTableView.dequeueReusableCell(withIdentifier: MainPageSideMenuFeatureCell.identifier, for: indexPath) as? MainPageSideMenuFeatureCell else { return UITableViewCell() }
            cell.bind(data: viewModel.fetchSideMenuItems()[indexPath.section][indexPath.row])
            if indexPath.row != viewModel.fetchSideMenuItems()[indexPath.section].count - 1 {
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
        guard let title = viewModel.fetchSideMenuItems()[indexPath.section][indexPath.row].title else { return }
        if title == "프로필" {
            if LoginManager.manager.isLogin() {
                guard let email = LoginManager.manager.email else { return }
                IndicatorMaker.showLoading()
                email.toNickName { nickName in
                    IndicatorMaker.hideLoading()
                    let vc = ProfilePageViewController(viewModel: ProfilePageViewModel(email: email, nickName: nickName))
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                let vc = SignInViewController(viewModel: SignInViewModel())
                navigationController?.pushViewController(vc, animated: true)
            }
        } else if title == "자유 게시판" {
            let vc = CommunityPageViewController(viewModel: CommunityPageViewModel(type: .normal))
            navigationController?.pushViewController(vc, animated: true)
        } else if title == "거래 게시판" {
            let vc = CommunityPageViewController(viewModel: CommunityPageViewModel(type: .sell))
            navigationController?.pushViewController(vc, animated: true)
        } else if title == "로그아웃" {
            AlertMaker.showAlertAction2(vc: self, title: "로그아웃", message: "정말로 로그아웃 하시겠습니까?", cancelTitle: "취소", completeTitle: "확인", nil) {
                IndicatorMaker.showLoading()
                LoginManager.manager.logOut { [weak self] _ in
                    self?.sideMenuTableView.reloadData()
                    IndicatorMaker.hideLoading()
                }
            }
        } else if title == "문의하기" {
            let vc = QnAViewController()
            navigationController?.pushViewController(vc, animated: true)
            
        } else if title == "회원 탈퇴" {
            AlertMaker.showAlertAction2(title: "회원 탈퇴", message: "회원 탈퇴 시 모든 데이터가 삭제됩니다.", cancelTitle: "확인", completeTitle: "취소", {
                guard let email = LoginManager.manager.email else { return }
                IndicatorMaker.showLoading()
                LoginManager.manager.deleteUser { [weak self] in
                    FirebaseManager.firebaseManager.deleteUserData(email: email) {
                        self?.sideMenuTableView.reloadData()
                        IndicatorMaker.hideLoading()
                        AlertMaker.showAlertAction1(title: "회원 탈퇴", message: "회원 탈퇴가 완료되었습니다.")
                    }
                }
            }, {})
        } else if title == "시뮬레이터" {
            print("시뮬레이터")
        } else if title == "앱정보" {
            let vc = AppInfoPageViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else if title == "개인정보처리 방침" {
            let privacyPolicyURL = URL(string: "https://plip.kr/pcc/26c2c65d-d3ca-4903-91f2-50a049b20636/privacy/1.html")!
            let safariViewController = SFSafariViewController(url: privacyPolicyURL)
            self.navigationController?.pushViewController(safariViewController, animated: true)
        }
    }
}
