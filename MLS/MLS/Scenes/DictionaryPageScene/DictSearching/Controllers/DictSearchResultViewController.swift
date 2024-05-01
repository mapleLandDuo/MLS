//
//  DictSearchResultViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 3/19/24.
//

import UIKit

import SnapKit

import RxSwift
import RxCocoa

class DictSearchResultViewController: BasicController {
    // MARK: - Properties
    
    private let viewModel: DictSearchViewModel
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Components
    
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
extension DictSearchResultViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
}

// MARK: - Bind
private extension DictSearchResultViewController {
    func bind() {
        viewModel.menuItems.bind(to: searchMenuCollectionView.rx.items(cellIdentifier: DictSearchMenuCell.identifier, cellType: DictSearchMenuCell.self)) {
            [weak self] index, item, cell in
            guard let self = self else { return }
            if self.viewModel.fetchSelectedMenuType() == item.type {
                let indexPath = IndexPath(row: index, section: 0)
                self.searchMenuCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init())
            }
            cell.bind(text: item.getMenuString)
        }.disposed(by: disposeBag)
        
        viewModel.dictDatas.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.searchTotalResultTableView.reloadData()
            self.searchMenuTappedResultTableView.reloadData()
            self.viewModel.setIsShowEmptyView()
        }.disposed(by: disposeBag)
        
        viewModel.selectedMenuType.subscribe { [weak self] type in
            guard let self = self else { return }
            self.searchMenuTappedResultTableView.isHidden = type == DictMenuTypeEnum.total
            self.searchTotalResultTableView.reloadData()
            self.searchMenuTappedResultTableView.reloadData()
            self.searchMenuCollectionView.reloadData()
            self.viewModel.setIsShowEmptyView()
        }.disposed(by: disposeBag)
        
        viewModel.isShowEmptyView.subscribe { [weak self] isShow in
            guard let self = self else { return }
            searchResultEmptyView.isHidden = !isShow
        }.disposed(by: disposeBag)
    }
}

// MARK: - SetUp
private extension DictSearchResultViewController {
    func setUp() {
        setUpRegister()
        setUpDelegate()
        setUpConstraints()
    }
    
    func setUpRegister() {
        searchTotalResultTableView.register(DictSearchDataCell.self, forCellReuseIdentifier: DictSearchDataCell.identifier)
        searchMenuTappedResultTableView.register(DictSearchDataCell.self, forCellReuseIdentifier: DictSearchDataCell.identifier)
        searchMenuCollectionView.register(DictSearchMenuCell.self, forCellWithReuseIdentifier: DictSearchMenuCell.identifier)
    }
    
    func setUpDelegate() {
        
        searchTotalResultTableView.dataSource = self
        searchTotalResultTableView.delegate = self
        
        searchMenuTappedResultTableView.dataSource = self
        searchMenuTappedResultTableView.delegate = self
        
        searchMenuCollectionView.delegate = self
    }
    
    func setUpConstraints() {
        
        view.addSubview(searchMenuCollectionView)
        view.addSubview(searchTotalResultTableView)
        view.addSubview(searchMenuTappedResultTableView)
        view.addSubview(searchResultEmptyView)
        
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

extension DictSearchResultViewController: DictSearchFilterHeaderViewDelegate {
    
    /// 필터 버튼 탭 이벤트
    /// - Parameter type: 몬스터, 도감, npc, 퀘스트, 맵 중 하나 선택
    func didTapFilterButton(type: DictType) {
        var vc = DictSearchFilterViewController(type: type, filter: viewModel.fetchFilter(type: type))
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        vc.title = "filter"
        vc.delegate = self
        present(vc, animated: true)
    }
    
    /// 필터 값 초기화 버튼 탭 이벤트
    /// - Parameter type: 몬스터, 도감, npc, 퀘스트, 맵 중 하나 선택
    func didTapFilterResetButton(type: DictType) {
        viewModel.setFilter(type: type, filter: DictSearchFilter())
    }
    
    /// 정렬 버튼 탭 이벤트
    /// - Parameter type: 몬스터, 도감, npc, 퀘스트, 맵 중 하나 선택
    func didTapSortedButton(type: DictType) {
        let sorted = viewModel.fetchSortedType(type: type)
        let vc =  DictSearchSortedViewController(type: type, selectSortedEnum: sorted)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        vc.delegate = self
        vc.title = "sorted"
        present(vc, animated: true)
    }
}
extension DictSearchResultViewController: DictSearchFilterViewControllerDelegate {
    
    ///  바텀 모달 내부의 필터 적용 버튼 탭 이벤트
    /// - Parameters:
    ///   - type: 몬스터, 도감, npc, 퀘스트, 맵
    ///   - filter: Filter Enum
    func didTapApplyButton(type: DictType, filter: DictSearchFilter) {
        viewModel.setFilter(type: type, filter: filter)
    }
    
    /// 바텀 모달 내부의 초기화 버튼 탭 이벤트
    /// - Parameter type: 몬스터, 도감, npc, 퀘스트, 맵
    func didTapResetButton(type: DictType) {
        viewModel.setFilter(type: type, filter: DictSearchFilter())
    }
}

extension DictSearchResultViewController: DictSearchSortedViewControllerDelegate {
    
    /// 정렬 적용후 화면 새로 고침 메서드
    /// - Parameters:
    ///   - type: 몬스터, 도감, npc, 퀘스트, 맵
    ///   - sortedEnum: 정렬 Enum
    func viewWillDisappear(type: DictType, sortedEnum: DictSearchSortedEnum) {
        viewModel.setSortedType(type: type, sortedType: sortedEnum)
    }
}

extension DictSearchResultViewController: DictSectionHeaderViewDelegate {
    
    /// 전체 보기 페이지 Header 전체보기 탭 이벤트
    /// - Parameter title: header Title
    func didTapShowButton(title: String?) {
        guard let title = title else { return }
        viewModel.setSelectedMenuType(rawValue: title)
    }
}

extension DictSearchResultViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        guard let title = presented.title else { return nil }
        switch viewModel.fetchSelectedMenuType() {
        case .monster:
            if title == "filter" {
                return PresentationController(presentedViewController: presented, presenting: presenting, size: DictType.monster.filterControllerSize)
            } else {
                return PresentationController(presentedViewController: presented, presenting: presenting, size: DictType.monster.sortedControllerSize)
            }
        case .item:
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

extension DictSearchResultViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.setSelectedMenuType(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(
            width:
                viewModel
                .fetchMenuItems()[indexPath.row]
                .getMenuString
                .size(withAttributes: [NSAttributedString.Key.font : UIFont.customFont(fontSize: .body_md, fontType: .semiBold) ?? 0])
                .width,
            height: Constants.spacings.xl_3
        )
        return size
    }
}

extension DictSearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.fetchSelectedMenuType() {
        case .total:
            return viewModel.fetchTotalDictDatas()[section].datas.count
        default:
            return viewModel.fetchDictDatas(type: viewModel.fetchSelectedMenuType()).datas.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch viewModel.fetchSelectedMenuType() {
        case .total:
            return viewModel.fetchTotalDictDatas().count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DictSearchDataCell.identifier, for: indexPath) as? DictSearchDataCell else { return UITableViewCell() }
        let keyword = viewModel.fetchSearchKeyword()
        cell.selectionStyle = .none
        switch viewModel.fetchSelectedMenuType() {
        case .total:
            cell.bind(data: viewModel.fetchTotalDictDatas()[indexPath.section].datas[indexPath.row], keyword: keyword)
        default:
            cell.bind(data: viewModel.fetchDictDatas(type: viewModel.fetchSelectedMenuType()).datas[indexPath.row], keyword: keyword)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if viewModel.fetchSelectedMenuType() == .total {
            let datas = viewModel.fetchTotalDictDatas()
            let view = DictSectionHeaderView(sectionDatas: datas[section])
            view.delegate = self
            return view
        } else {
            let view = DictSearchFilterHeaderView(
                selectedMenuIndex: viewModel.fetchSelectedMenuType().convertToInt(),
                sorted: viewModel.fetchSortedType(type: viewModel.fetchSelectedMenuType().convertToDictType())
            )
            view.delegate = self
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var data: DictSectionData
        if viewModel.fetchSelectedMenuType() == .total {
            data = viewModel.fetchTotalDictDatas()[indexPath.section].datas[indexPath.row]
        } else {
            data = viewModel.fetchDictDatas(type: viewModel.fetchSelectedMenuType()).datas[indexPath.row]
        }
        FirebaseManager.firebaseManager.countUpDictSearch(type: data.type, name: data.title)
        switch data.type {
        case .monster:
            let vm = DictMonsterViewModel(selectedName: data.title, type: .monster)
            let vc = DictMonsterViewController(viewModel: vm)
            navigationController?.pushViewController(vc, animated: true)
        case .item:
            let vm = DictItemViewModel(selectedName: data.title, type: .item)
            let vc = DictItemViewController(viewModel: vm)
            navigationController?.pushViewController(vc, animated: true)
        case .map:
            let vm = DictMapViewModel(selectedName: data.title, type: .map)
            let vc = DictMapViewController(viewModel: vm)
            navigationController?.pushViewController(vc, animated: true)
        case .npc:
            let vm = DictNPCViewModel(selectedName: data.title, type: .npc)
            let vc = DictNPCViewController(viewModel: vm)
            navigationController?.pushViewController(vc, animated: true)
        case .quest:
            let vm = DictQuestViewModel(selectedName: data.title, type: .quest)
            let vc = DictQuestViewController(viewModel: vm)
            navigationController?.pushViewController(vc, animated: true)
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
            switch viewModel.fetchSelectedMenuType() {
            case .monster, .item:
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
        if viewModel.fetchSelectedMenuType() != .total {
            if tableView == searchMenuTappedResultTableView {
                let count = viewModel.fetchDictDatas(type: viewModel.fetchSelectedMenuType()).datas.count
                return count == 0 ? 0 : Constants.spacings.xl
            }
        }
        return Constants.spacings.xl
    }
}
