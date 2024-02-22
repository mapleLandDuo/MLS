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

    var viewModel: DictLandingViewModel
    
    // MARK: - Components
    
    var firstSectionView = DictLandingSearchView()
    
    var separatorView: UIView = {
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
    
    var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.separatorStyle = .none
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
        viewModel.fetchSectionDatas()
    }
}

// MARK: - SetUp
private extension DictLandingViewController {
    func setUp() {
        setUpConstraints()
        setUpNavigation()
        firstSectionView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DictHorizontalSectionTableViewCell.self, forCellReuseIdentifier: DictHorizontalSectionTableViewCell.identifier)
    }
    
    func setUpNavigation() {
        
        let inquireButton = InquireButton()
        let leftButton = UIBarButtonItem(customView: inquireButton)
        
        let jobBadgeButton = JobBadgeButton(job: "전사", level: "58")
        let myPageButton = MyPageIconButton()
        
        let rightButtonItems = [UIBarButtonItem(customView: jobBadgeButton), UIBarButtonItem(customView: myPageButton)]
        
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItems = rightButtonItems
    }
    
    func setUpConstraints() {
        view.addSubview(firstSectionView)
        view.addSubview(separatorView)
        view.addSubview(tableView)
        
        firstSectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(firstSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(Constants.spacings.xl_2)
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

extension DictLandingViewController: DictLandingSearchViewDelegate {
    func didTapSearchButton() {
        print(#function)
        let vc = DictSearchViewController(viewModel: DictSearchViewModel())
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapShortCutButton() {
        print(#function)
    }
}

extension DictLandingViewController: DictHorizontalSectionTableViewCellDelegate {
    func didSelectItemAt(itemTitle: String?) {
        print(itemTitle)
    }
    
    func didTapCellButton(sectionTitle: String?) {
        print(sectionTitle)
    }
}

extension DictLandingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.fetchSectionHeaderInfos()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DictHorizontalSectionTableViewCell.identifier, for: indexPath) as? DictHorizontalSectionTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        guard let datas = viewModel.fetchSectionHeaderInfos() else { return UITableViewCell() }
        cell.bind(data: datas[indexPath.section])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Constants.spacings.xl_3
    }
}
