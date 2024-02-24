//
//  DictSearchViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 2/22/24.
//

import UIKit

import SnapKit

class DictSearchViewController: BasicController {
    // MARK: - Properties
    
    private let viewModel: DictSearchViewModel
    
    // MARK: - Components
    
    private let headerView = DictSearchHeaderView()
    
    private let searchingView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    private let recentSearchKeywordCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.spacings.md
        layout.sectionInset = .init(top: 0, left: Constants.spacings.xl, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private let recentSearchClearButton: UIButton = {
        let button = UIButton()
        button.setTitle("모두 지우기", for: .normal)
        button.setTitleColor(.semanticColor.text.info, for: .normal)
        button.titleLabel?.font = .customFont(fontSize: .body_sm, fontType: .medium)
        return button
    }()
    
    private let searchView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let searchMenuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.spacings.md
        layout.sectionInset = .init(top: 0, left: Constants.spacings.xl, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        let backgroundView = UIView()
        let separator = UIView()
        separator.backgroundColor = .semanticColor.bolder.secondary
        backgroundView.addSubview(separator)
        separator.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(1)
            $0.height.equalTo(1)
        }
        view.backgroundView = backgroundView
        return view
    }()
    
    private let searchResultTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.separatorStyle = .none
        view.backgroundColor = .white
        return view
    }()
    
    private let searchResultEmptyView: DictSearchEmptyView = {
        let view = DictSearchEmptyView()
        view.isHidden = true
        return view
    }()
    
    init(viewModel: DictSearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - LifeCycle
extension DictSearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.headerView.searchTextField.becomeFirstResponder()
        }
        
    }
}

// MARK: - Bind
private extension DictSearchViewController {
    func bind() {
        let manager = UserDefaultsManager()
        viewModel.recentSearchKeywords.bind { [weak self] keywords in
            guard let keywords = keywords else { return }
            manager.setRecentSearchKeyWord(keyWords: keywords)
            self?.recentSearchKeywordCollectionView.reloadData()
        }
        viewModel.searchData.bind { [weak self] datas in
            guard let datas = datas else { return }
            let count = datas.map({$0.datas.count}).reduce(0) { $0 + $1 }
            if count == 0 {
                self?.searchResultEmptyView.isHidden = false
            } else {
                self?.searchResultEmptyView.isHidden = true
            }
            self?.searchResultTableView.reloadData()
        }
        viewModel.searchMenus.bind { [weak self] _ in
            self?.searchMenuCollectionView.reloadData()
        }
    }
}

// MARK: - SetUp
private extension DictSearchViewController {
    
    func setUp() {
        setUpConstraints()
        setUpAddAction()
        setUpDelegate()
        setUpRegister()
    }
    
    func setUpRegister() {
        searchResultTableView.register(DictSearchDataCell.self, forCellReuseIdentifier: DictSearchDataCell.identifier)
        recentSearchKeywordCollectionView.register(RecentSearchKeywordCell.self, forCellWithReuseIdentifier: RecentSearchKeywordCell.identifier)
        searchMenuCollectionView.register(DictSearchMenuCell.self, forCellWithReuseIdentifier: DictSearchMenuCell.identifier)
    }
    
    func setUpDelegate() {
        headerView.searchTextField.delegate = self
        
        recentSearchKeywordCollectionView.dataSource = self
        recentSearchKeywordCollectionView.delegate = self
        
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
        
        searchMenuCollectionView.dataSource = self
        searchMenuCollectionView.delegate = self
    }
    
    func setUpAddAction() {
        headerView.backButton.addAction(UIAction(handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }), for: .primaryActionTriggered)
        headerView.searchClearButton.addAction(UIAction(handler: { [weak self] _ in
            self?.headerView.searchTextField.text = ""
        }), for: .primaryActionTriggered)
        recentSearchClearButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.recentSearchKeywords.value = []
            self.searchView.isHidden = false
            self.searchingView.isHidden = true
        }), for: .primaryActionTriggered)
    }
    
    func setUpConstraints() {
        
        view.addSubview(headerView)
        view.addSubview(searchingView)
        view.addSubview(searchView)
        searchingView.addSubview(recentSearchKeywordCollectionView)
        searchingView.addSubview(recentSearchClearButton)
        searchView.addSubview(searchMenuCollectionView)
        searchView.addSubview(searchResultTableView)
        searchView.addSubview(searchResultEmptyView)

        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        searchingView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        recentSearchKeywordCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.spacings.xl_3)
        }
        
        recentSearchClearButton.snp.makeConstraints {
            $0.top.equalTo(recentSearchKeywordCollectionView.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(Constants.spacings.xl)
        }
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        searchMenuCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.spacings.xl_3 + 3)
        }
        
        searchResultTableView.snp.makeConstraints {
            $0.top.equalTo(searchMenuCollectionView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchResultEmptyView.snp.makeConstraints {
            $0.top.equalTo(searchMenuCollectionView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension DictSearchViewController: DictSectionHeaderViewDelegate {
    func didTapShowButton(title: String?) {
        print(title)
    }
}

extension DictSearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let keyword = textField.text else { return true }
        viewModel.recentSearchKeywords.value?.insert(keyword, at: 0)
        viewModel.fetchSearchData(keyword: keyword)
        view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        headerView.searchTrailingView.layer.borderColor = UIColor.semanticColor.bolder.interactive.primary_pressed?.cgColor
        headerView.searchClearButton.isHidden = false
        guard let keywords = viewModel.recentSearchKeywords.value else { return }
        if keywords.isEmpty {
            searchView.isHidden = false
            searchingView.isHidden = true
        } else {
            searchView.isHidden = true
            searchingView.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        headerView.searchTrailingView.layer.borderColor = UIColor.semanticColor.bolder.interactive.secondary?.cgColor
        headerView.searchClearButton.isHidden = true
        searchView.isHidden = false
        searchingView.isHidden = true
    }
}

extension DictSearchViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.recentSearchKeywordCollectionView:
            return viewModel.recentSearchKeywords.value?.count ?? 0
        case self.searchMenuCollectionView:
            return viewModel.searchMenus.value?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.recentSearchKeywordCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchKeywordCell.identifier, for: indexPath) as? RecentSearchKeywordCell else { return UICollectionViewCell() }
            cell.bind(text: viewModel.recentSearchKeywords.value?[indexPath.row], index: indexPath.row)
            cell.delegate = self
            return cell
        case self.searchMenuCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DictSearchMenuCell.identifier, for: indexPath) as? DictSearchMenuCell else { return UICollectionViewCell() }
            cell.bind(text: viewModel.searchMenus.value?[indexPath.row])
            if indexPath.item == 0 {
                cell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
              }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.recentSearchKeywordCollectionView :
            guard let keyword = viewModel.recentSearchKeywords.value?[indexPath.row] else { return }
            viewModel.fetchSearchData(keyword: keyword)
            headerView.searchTextField.text = keyword
            view.endEditing(true)
        default:
            print("tap")
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.recentSearchKeywordCollectionView:
            guard let keywords = viewModel.recentSearchKeywords.value else { return .zero }
            return .init(
                width: keywords[indexPath.row].size(withAttributes: [NSAttributedString.Key.font : UIFont.customFont(fontSize: .body_sm, fontType: .medium) ?? 0]).width + (Constants.spacings.md * 2) + Constants.spacings.xl + Constants.spacings.xs_2 + 5,
                height: Constants.spacings.xl_3)
        case self.searchMenuCollectionView:
            guard let keywords = viewModel.searchMenus.value else { return .zero }
            return .init(
                width: keywords[indexPath.row].size(withAttributes: [NSAttributedString.Key.font : UIFont.customFont(fontSize: .body_md, fontType: .semiBold) ?? 0]).width,
                height: Constants.spacings.xl_3)
        default:
            return .zero
        }
    }
}

extension DictSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchData.value?.filter({!$0.datas.isEmpty})[section].datas.count ?? 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.searchData.value?.filter({!$0.datas.isEmpty}).count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let datas = viewModel.searchData.value?.filter({!$0.datas.isEmpty}) else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DictSearchDataCell.identifier, for: indexPath) as? DictSearchDataCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.bind(data: datas[indexPath.section].datas[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let datas = viewModel.searchData.value?.filter({!$0.datas.isEmpty}) else { return nil }
        let view = DictSectionHeaderView(image: datas[section].iconImage, title: datas[section].description)
        view.delegate = self
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let datas = viewModel.searchData.value?.filter({!$0.datas.isEmpty}) else { return }
        print(datas[indexPath.section].datas[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return Constants.spacings.lg + 48
        default:
            return Constants.spacings.lg + 24 + Constants.spacings.xl_3
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        let separator = UIView()
        separator.backgroundColor = .semanticColor.bolder.primary
        view.addSubview(separator)
        separator.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Constants.spacings.xl
    }
}

extension DictSearchViewController: RecentSearchKeywordCellDelegate {
    func didTapDeleteButton(index: Int) {
        viewModel.recentSearchKeywords.value?.remove(at: index)
        guard let keywords = viewModel.recentSearchKeywords.value else { return }
        if keywords.isEmpty {
            searchView.isHidden = false
            searchingView.isHidden = true
        } else {
            searchView.isHidden = true
            searchingView.isHidden = false
        }
    }
}
