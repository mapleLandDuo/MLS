//
//  DictLandingViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 2/18/24.
//

import UIKit

import SnapKit

import FirebaseAuth
import MessageUI

class DictLandingViewController: BasicController {
    // MARK: - Properties

    private let viewModel: DictLandingViewModel
    
    // MARK: - Components
    
    private let headerView = DictLandingHeaderView()
    
    private let firstSectionView = DictLandingSearchView()
    
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.separatorStyle = .none
        view.backgroundColor = .white
        return view
    }()

    init(viewModel: DictLandingViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension DictLandingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setUp()
        checkAnnouncementData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
        //인기 몬스터, 아이템 데이터 패치
        IndicatorManager.showIndicator(vc: self)
        viewModel.fetchSectionDatas() {
            IndicatorManager.hideIndicator(vc: self)
        }
        
        //로그인 한 경우 직업 뱃지 데이터 패치
        if LoginManager.manager.isLogin() {
            IndicatorManager.showIndicator(vc: self)
            guard let email = LoginManager.manager.email else { return }
            FirebaseManager.firebaseManager.fetchUserData(userEmail: email) { [weak self] user in
                guard let self = self else { return }
                self.headerView.resetJobBadge(user: user)
                self.headerView.isLoginButtonShow(isShow: false)
                IndicatorManager.hideIndicator(vc: self)
            }
        } else {
            headerView.isLoginButtonShow(isShow: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
}

// MARK: - SetUp
private extension DictLandingViewController {
    func setUp() {
        setUpConstraints()
        headerView.delegate = self
        firstSectionView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        headerView.isLoginButtonShow(isShow: true)
        tableView.register(DictHorizontalSectionTableViewCell.self, forCellReuseIdentifier: DictHorizontalSectionTableViewCell.identifier)
    }
    
    func setUpConstraints() {
        view.addSubview(headerView)
        view.addSubview(firstSectionView)
        view.addSubview(tableView)
        
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(56)
        }
        
        firstSectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(firstSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - Bind
private extension DictLandingViewController {
    func bind() {
        viewModel.sectionHeaderInfos.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - Methods
private extension DictLandingViewController {
    func checkMail() {
        let sendMailErrorAlert = UIAlertController(title: "메일을 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        sendMailErrorAlert.addAction(confirmAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
}

extension DictLandingViewController: DictLandingHeaderViewDelegate {
    
    // 로그인, 회원가입 버튼 탭
    func didTapSignInButton() {
        let vc = LoginViewController(viewModel: LoginViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 문의하기 버튼 탭
    func didTapInquireButton() {
        if MFMailComposeViewController.canSendMail() {
            let compseViewController = MFMailComposeViewController()
            compseViewController.setToRecipients(["maplelands2024@gmail.com"])
            compseViewController.setSubject("문의하기")
            compseViewController.setMessageBody("문의 내용을 자세하게 입력해 주세요!", isHTML: false)
            self.present(compseViewController, animated: true, completion: nil)
        } else {
            print(Error.self)
            self.checkMail()
        }
    }
    
    // 직업 뱃지 버튼 탭
    func didTapJobBadgeButton() {
        print(#function)

    }
    
    // 마이페이지 버튼 탭
    func didTapMyPageButton() {
        self.headerView.myPageIconButton.isUserInteractionEnabled = false
        guard let email = LoginManager.manager.email else {
            self.headerView.myPageIconButton.isUserInteractionEnabled = true
            return
        }
        IndicatorManager.showIndicator(vc: self)
        FirebaseManager.firebaseManager.fetchUserData(userEmail: email) { [weak self] user in
            guard let self = self else { return }
            IndicatorManager.hideIndicator(vc: self)
            let vc = MyPageViewController(user: user)
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
            self.headerView.myPageIconButton.isUserInteractionEnabled = true
        }
    }
}

extension DictLandingViewController: MyPageViewControllerDelegate {
    
    // 마이페이지 회원탈퇴 버튼 탭
    func didTapSecessionButton() {
        AlertManager.showAlert(
            vc: self,
            type: .green,
            title: "회원 탈퇴 완료",
            description: "다시 가입을 원하시면 회원가입을 눌러주세요",
            location: .bottom
        )
    }
}

extension DictLandingViewController: DictLandingSearchViewDelegate {
    
    // 서치바 탭
    func didTapSearchButton() {
        let vc = DictSearchViewController(viewModel: DictSearchViewModel())
        vc.headerView.searchTextField.becomeFirstResponder()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 도감 바로가기 버튼 탭
    func didTapShortCutButton() {
        let viewModel = DictSearchViewModel()
        viewModel.fetchAllSearchData()
        let vc = DictSearchViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DictLandingViewController: DictSectionHeaderViewDelegate {
    
    // 사람들이 많이 찾는 @@@ 탭
    func didTapShowButton(title: String?) {
        guard let datas = viewModel.sectionHeaderInfos.value,
              let title = title else { return }
        let vm = PopularViewModel(datas: datas, title: title)
        let vc = PopularViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DictLandingViewController: DictHorizontalSectionTableViewCellDelegate {
    
    // 사람들이 많이 찾는 Cell 탭
    func didSelectItemAt(itemTitle: String, type: DictType) {
        FirebaseManager.firebaseManager.countUpDictSearch(type: type, name: itemTitle)
        var vc: BasicController
        switch type {
        case .monster:
            let vm = DictMonsterViewModel(selectedName: itemTitle)
            vc = DictMonsterViewController(viewModel: vm)
        case .item:
            let vm = DictItemViewModel(selectedName: itemTitle)
            vc = DictItemViewController(viewModel: vm)
        case .map:
            let vm = DictMapViewModel(selectedName: itemTitle)
            vc = DictMapViewController(viewModel: vm)
        case .npc:
            let vm = DictNPCViewModel(selectedName: itemTitle)
            vc = DictNPCViewController(viewModel: vm)
        case .quest:
            let vm = DictQuestViewModel(selectedName: itemTitle)
            vc = DictQuestViewController(viewModel: vm)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DictLandingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.fetchSectionHeaderInfos().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DictHorizontalSectionTableViewCell.identifier, for: indexPath) as? DictHorizontalSectionTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        let datas = viewModel.fetchSectionHeaderInfos()
        cell.bind(data: datas[indexPath.section])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let datas = viewModel.fetchSectionHeaderInfos()
        let view = DictSectionHeaderView(sectionDatas: datas[section])
        view.delegate = self
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return Constants.spacings.lg + 24 + 24
        default:
            return Constants.spacings.lg + 24
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Constants.spacings.xl_3
    }
}
