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
    
    let headerView = DictSearchHeaderView()
    
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
    
    private let searchTotalResultTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.separatorStyle = .none
        view.backgroundColor = .white
        return view
    }()
    
    private let searchMenuTappedResultTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.separatorStyle = .none
        view.backgroundColor = .white
        view.isHidden = true
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
}

// MARK: - Bind
private extension DictSearchViewController {
    func bind() {
        let manager = UserDefaultsManager()
        viewModel.recentSearchKeywords.bind { [weak self] keywords in
            guard let keywords = keywords else { return }
            manager.setRecentSearchKeyWord(keyWords: keywords)
            self?.recentSearchKeywordCollectionView.reloadData()
            self?.searchMenuTappedResultTableView.reloadData()
        }
        
        viewModel.searchData.bind { [weak self] datas in
            guard let self = self else { return }
            guard let datas = datas else { return }
            if self.viewModel.fetchMenuIndex() == 0 {
                let count = datas.map({$0.datas.count}).reduce(0) { $0 + $1 }
                if count == 0 {
                    self.searchResultEmptyView.isHidden = false
                } else {
                    self.searchResultEmptyView.isHidden = true
                }
            } else {
                let count = datas[self.viewModel.fetchMenuIndex() - 1].datas.count
                if count == 0 {
                    self.searchResultEmptyView.isHidden = false
                } else {
                    self.searchResultEmptyView.isHidden = true
                }
            }

            self.searchTotalResultTableView.reloadData()
            self.searchMenuTappedResultTableView.reloadData()
            self.searchMenuCollectionView.reloadData()
        }
        
        viewModel.selectedMenuIndex.bind { [weak self] index in
            guard let index = index else { return }
            if index != 0 {
                self?.searchTotalResultTableView.isHidden = true
                self?.searchMenuTappedResultTableView.isHidden = false
                guard let count = self?.viewModel.searchData.value?[index - 1].datas.count else { return }
                if count == 0 {
                    self?.searchResultEmptyView.isHidden = false
                } else {
                    self?.searchResultEmptyView.isHidden = true
                }
            } else {
                self?.searchTotalResultTableView.isHidden = false
                self?.searchMenuTappedResultTableView.isHidden = true
                guard let datas = self?.viewModel.searchData.value else { return }
                let count = datas.map({$0.datas.count}).reduce(0){ $0 + $1 }
                if count == 0 {
                    self?.searchResultEmptyView.isHidden = false
                } else {
                    self?.searchResultEmptyView.isHidden = true
                }
            }
            self?.searchTotalResultTableView.reloadData()
            self?.searchMenuTappedResultTableView.reloadData()
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
        searchTotalResultTableView.register(DictSearchDataCell.self, forCellReuseIdentifier: DictSearchDataCell.identifier)
        searchMenuTappedResultTableView.register(DictSearchDataCell.self, forCellReuseIdentifier: DictSearchDataCell.identifier)
        recentSearchKeywordCollectionView.register(RecentSearchKeywordCell.self, forCellWithReuseIdentifier: RecentSearchKeywordCell.identifier)
        searchMenuCollectionView.register(DictSearchMenuCell.self, forCellWithReuseIdentifier: DictSearchMenuCell.identifier)
    }
    
    func setUpDelegate() {
        headerView.searchTextField.delegate = self
        
        recentSearchKeywordCollectionView.dataSource = self
        recentSearchKeywordCollectionView.delegate = self
        
        searchTotalResultTableView.dataSource = self
        searchTotalResultTableView.delegate = self
        
        searchMenuTappedResultTableView.dataSource = self
        searchMenuTappedResultTableView.delegate = self
        
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
        searchView.addSubview(searchTotalResultTableView)
        searchView.addSubview(searchMenuTappedResultTableView)
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
        
        searchTotalResultTableView.snp.makeConstraints {
            $0.top.equalTo(searchMenuCollectionView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchMenuTappedResultTableView.snp.makeConstraints {
            $0.top.equalTo(searchMenuCollectionView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchResultEmptyView.snp.makeConstraints {
            $0.top.equalTo(searchMenuCollectionView.snp.bottom).offset(102)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension DictSearchViewController: DictSearchFilterHeaderViewDelegate {
    func didTapFilterButton(type: DictType) {
        var vc: DictSearchFilterViewController
        switch type {
        case .item:
            vc = DictSearchFilterViewController(type: type, filter: viewModel.itemFilter, searchKeyword: viewModel.searchKeyword)
        case .monster:
            vc = DictSearchFilterViewController(type: type, filter: viewModel.monsterFilter, searchKeyword: viewModel.searchKeyword)
        default:
            return
        }
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        vc.title = "filter"
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func didTapFilterResetButton(type: DictType) {
        viewModel.setFilterDataToOriginData()
        switch type {
        case .item:
            viewModel.itemFilter = DictSearchFilter()
        case .monster:
            viewModel.monsterFilter = DictSearchFilter()
        default:
            print(#function)
        }
    }
    
    func didTapSortedButton(type: DictType) {
        let sorted = viewModel.fetchSortedEnum(type: type)
        let vc =  DictSearchSortedViewController(type: type, selectSortedEnum: sorted)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        vc.delegate = self
        vc.title = "sorted"
        present(vc, animated: true)
    }
}
extension DictSearchViewController: DictSearchFilterViewControllerDelegate {
    func didTapApplyButton(type: DictType, datas: [Any], filter: DictSearchFilter) {
        viewModel.setFilterData(type: type, datas: datas)
        switch type {
        case .item:
            viewModel.itemFilter = filter
        case .monster:
            viewModel.monsterFilter = filter
        default:
            print(#function)
        }
    }
    
    func didTapResetButton(type: DictType) {
        viewModel.setFilterDataToOriginData()
        switch type {
        case .item:
            viewModel.itemFilter = DictSearchFilter()
        case .monster:
            viewModel.monsterFilter = DictSearchFilter()
        default:
            print(#function)
        }
    }
}
extension DictSearchViewController: DictSearchSortedViewControllerDelegate {
    func viewWillDisappear(type: DictType, sortedEnum: DictSearchSortedEnum) {
        viewModel.setSortedEnum(type: type, sorted: sortedEnum)
    }
}

extension DictSearchViewController: DictSectionHeaderViewDelegate {
    func didTapShowButton(title: String?) {
        guard let title = title else { return }
        switch title {
        case "몬스터":
            viewModel.setMenuIndex(index: 1)
        case "아이템":
            viewModel.setMenuIndex(index: 2)
        case "맵":
            viewModel.setMenuIndex(index: 3)
        case "NPC":
            viewModel.setMenuIndex(index: 4)
        case "퀘스트":
            viewModel.setMenuIndex(index: 5)
        default:
            viewModel.setMenuIndex(index: 0)
        }
        searchMenuCollectionView.reloadData()
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

extension DictSearchViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    
        guard let title = presented.title else { return nil }
        
        switch viewModel.fetchMenuIndex() {
        case 1:
            if title == "filter" {
                return PresentationController(presentedViewController: presented, presenting: presenting, size: DictType.monster.filterControllerSize)
            } else {
                return PresentationController(presentedViewController: presented, presenting: presenting, size: DictType.monster.sortedControllerSize)
            }
        case 2:
            if title == "filter" {
                return PresentationController(presentedViewController: presented, presenting: presenting, size: DictType.item.filterControllerSize)
            } else {
                return PresentationController(presentedViewController: presented, presenting: presenting, size: DictType.item.sortedControllerSize)
            }
        default:
            return nil
        }
        
    }
}

extension DictSearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let keyword = textField.text else { return true }
        if keyword == "" {
            viewModel.fetchAllSearchData()
        } else {
            guard let keywords = viewModel.recentSearchKeywords.value else { return true }
            var cleanKeywords: [String] = [keyword]
            for keyword in keywords {
                if !cleanKeywords.contains(keyword) { cleanKeywords.append(keyword) }
            }
            viewModel.recentSearchKeywords.value = cleanKeywords
            viewModel.fetchSearchData(keyword: keyword)
        }
        viewModel.searchKeyword = keyword
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
            return viewModel.searchMenus.count
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
            cell.bind(text: viewModel.searchMenus[indexPath.row])
            if indexPath.item == viewModel.fetchMenuIndex() {
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
            guard let keywords = viewModel.recentSearchKeywords.value else { return }
            let keyword = keywords[indexPath.row]
            var cleanKeywords: [String] = [keyword]
            for keyword in keywords {
                if !cleanKeywords.contains(keyword) { cleanKeywords.append(keyword) }
            }
            viewModel.recentSearchKeywords.value = cleanKeywords
            viewModel.fetchSearchData(keyword: keyword)
            headerView.searchTextField.text = keyword
            viewModel.searchKeyword = keyword
            view.endEditing(true)
        default:
            viewModel.setMenuIndex(index: indexPath.row)
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
            return .init(
                width: viewModel.searchMenus[indexPath.row].size(withAttributes: [NSAttributedString.Key.font : UIFont.customFont(fontSize: .body_md, fontType: .semiBold) ?? 0]).width,
                height: Constants.spacings.xl_3)
        default:
            return .zero
        }
    }
}

extension DictSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.fetchMenuIndex() {
        case 0:
            return viewModel.searchData.value?.filter({!$0.datas.isEmpty})[section].datas.count ?? 0
        default:
            return viewModel.searchData.value?[viewModel.fetchMenuIndex() - 1].datas.count ?? 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch viewModel.fetchMenuIndex() {
        case 0:
            return viewModel.fetchSearchData().filter({!$0.datas.isEmpty}).count
        default:
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DictSearchDataCell.identifier, for: indexPath) as? DictSearchDataCell,
              let keyword = self.headerView.searchTextField.text else { return UITableViewCell() }
        cell.selectionStyle = .none
        switch viewModel.fetchMenuIndex() {
        case 0:
            let datas = viewModel.fetchSearchData().filter({!$0.datas.isEmpty})
            cell.bind(data: datas[indexPath.section].datas[indexPath.row],keyword: keyword)
        default:
            let datas = viewModel.fetchSearchData()
            cell.bind(data: datas[viewModel.fetchMenuIndex() - 1].datas[indexPath.row],keyword: keyword)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch tableView {
        case self.searchTotalResultTableView:
            guard let datas = viewModel.searchData.value?.filter({!$0.datas.isEmpty}) else { return nil }
            if datas.isEmpty { return nil }
            let view = DictSectionHeaderView(image: datas[section].iconImage, title: datas[section].description)
            view.delegate = self
            return view
        default :
            switch viewModel.fetchMenuIndex() {
            case 1:
                let view = DictSearchFilterHeaderView(selectedMenuIndex: viewModel.fetchMenuIndex(), sorted: viewModel.fetchSortedEnum(type: .monster))
                view.delegate = self
                return view
            case 2:
                let view = DictSearchFilterHeaderView(selectedMenuIndex: viewModel.fetchMenuIndex(), sorted: viewModel.fetchSortedEnum(type: .item))
                view.delegate = self
                return view
            case 3:
                let view = DictSearchFilterHeaderView(selectedMenuIndex: viewModel.fetchMenuIndex(), sorted: viewModel.fetchSortedEnum(type: .map))
                view.delegate = self
                return view
            case 4:
                let view = DictSearchFilterHeaderView(selectedMenuIndex: viewModel.fetchMenuIndex(), sorted: viewModel.fetchSortedEnum(type: .npc))
                view.delegate = self
                return view
            case 5:
                let view = DictSearchFilterHeaderView(selectedMenuIndex: viewModel.fetchMenuIndex(), sorted: viewModel.fetchSortedEnum(type: .quest))
                view.delegate = self
                return view
            default:
                let view = DictSearchFilterHeaderView(selectedMenuIndex: viewModel.fetchMenuIndex(), sorted: .defaultSorted)
                view.delegate = self
                return view
            }

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var datas: [DictSectionDatas]
        if viewModel.fetchMenuIndex() == 0 {
            datas = viewModel.fetchSearchData().filter({!$0.datas.isEmpty})
            let data = datas[indexPath.section].datas[indexPath.row]
            FirebaseManager.firebaseManager.countUpDictSearch(type: data.type, name: data.title)
        } else {
            datas = viewModel.fetchSearchData()
            let data = datas[viewModel.fetchMenuIndex() - 1].datas[indexPath.row]
            FirebaseManager.firebaseManager.countUpDictSearch(type: data.type, name: data.title)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableView {
        case self.searchTotalResultTableView:
            switch section {
            case 0:
                return Constants.spacings.lg + 48
            default:
                return Constants.spacings.lg + 24 + Constants.spacings.xl_3
            }
        default :
            switch viewModel.fetchMenuIndex() {
            case 1,2:
                return 102
            default:
                return 0
            }
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

        if viewModel.fetchMenuIndex() != 0 {
            if tableView == searchMenuTappedResultTableView {
                let count = viewModel.fetchSearchData()[viewModel.fetchMenuIndex() - 1].datas.count
                return count == 0 ? 0 : Constants.spacings.xl
            }
        }
        return Constants.spacings.xl
    }
}


