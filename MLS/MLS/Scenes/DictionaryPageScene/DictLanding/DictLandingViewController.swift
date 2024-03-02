//
//  DictLandingViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 2/18/24.
//

import UIKit

import SnapKit

class DictLandingViewController: BasicController {
    // MARK: - Properties

    private let viewModel: DictLandingViewModel
    
    // MARK: - Components
    
    private let headerView = DictLandingHeaderView()
    
    private let firstSectionView = DictLandingSearchView()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .semanticColor.bg.primary
        let separator = UIView()
        separator.backgroundColor = .semanticColor.bolder.secondary
        
        view.addSubview(separator)
        separator.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        return view
    }()
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        viewModel.fetchSectionDatas()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
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
        tableView.register(DictHorizontalSectionTableViewCell.self, forCellReuseIdentifier: DictHorizontalSectionTableViewCell.identifier)
    }
    
    func setUpConstraints() {
        
        view.addSubview(headerView)
        view.addSubview(firstSectionView)
        view.addSubview(separatorView)
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
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(firstSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom)
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

extension DictLandingViewController: DictLandingHeaderViewDelegate {
    func didTapSignInButton() {
        print(#function)
        let vc = LoginViewController(viewModel: LoginViewModel())
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapInquireButton() {
        print(#function)
        headerView.isLoginButtonShow(isShow: true)
    }
    
    func didTapJobBadgeButton() {
        print(#function)
        headerView.resetJobBadge(job: "전사", level: "56")
    }
    
    func didTapMyPageButton() {
        print(#function)
        let vc = MyPageViewController(viewModel: MyPageViewModel())
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension DictLandingViewController: MyPageViewControllerDelegate {
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
    func didTapSearchButton() {
        print(#function)
        let vc = DictSearchViewController(viewModel: DictSearchViewModel())
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapShortCutButton() {
        print(#function)
        let viewModel = DictSearchViewModel()
        viewModel.fetchAllSearchData()
        let vc = DictSearchViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension DictLandingViewController: DictSectionHeaderViewDelegate {
    func didTapShowButton(title: String?) {
        print(title)
    }
}

extension DictLandingViewController: DictHorizontalSectionTableViewCellDelegate {
    func didSelectItemAt(itemTitle: String, type: DictType) {
        print(itemTitle, type)
        FirebaseManager.firebaseManager.countUpDictSearch(type: type, name: itemTitle)
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
        let view = DictSectionHeaderView(image: datas[section].iconImage, title: datas[section].description)
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


