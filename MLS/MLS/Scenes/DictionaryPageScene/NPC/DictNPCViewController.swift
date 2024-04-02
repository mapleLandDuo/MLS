//
//  DictNPCViewController.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/03.
//

import UIKit

import SnapKit
import RxCocoa
import RxDataSources

class DictNPCViewController: BasicController {
    // MARK: Properties

    let viewModel: DictNPCViewModel

    // MARK: Components

    private let dictNPCTableView: UITableView = {
        let view = UITableView()
        view.register(DictMainInfoCell.self, forCellReuseIdentifier: DictMainInfoCell.identifier)
        view.register(DictTagTableViewCell.self, forCellReuseIdentifier: DictTagTableViewCell.identifier)
        view.separatorStyle = .none
        return view
    }()

    private let infoMenuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 0, left: Constants.spacings.xl, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Constants.spacings.xl_3
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.register(DictSearchMenuCell.self, forCellWithReuseIdentifier: DictSearchMenuCell.identifier)
        return view
    }()

    init(viewModel: DictNPCViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Life Cycle
extension DictNPCViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
}

// MARK: SetUp
private extension DictNPCViewController {
    func setUp() {
        dictNPCTableView.delegate = self

        infoMenuCollectionView.delegate = self
        infoMenuCollectionView.dataSource = self

        setUpConstraints()
        setUpNavigation(title: "상세정보")
    }

    func setUpConstraints() {
        view.addSubview(dictNPCTableView)

        dictNPCTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: Bind
extension DictNPCViewController {
    func bind() {
        let dataSource = RxTableViewSectionedReloadDataSource<Section>(
            configureCell: { [weak self] _, tableView, indexPath, item in
                var cell = UITableViewCell()
                if indexPath.section == 0 {
                    switch item {
                    case .mainInfo(let mainInfo):
                        guard let tempCell = tableView.dequeueReusableCell(withIdentifier: DictMainInfoCell.identifier, for: indexPath) as? DictMainInfoCell else { return UITableViewCell() }
                        tempCell.delegate = self
                        tempCell.bind(item: mainInfo)
                        cell = tempCell
                    default:
                        break
                    }
                } else {
                    switch item {
                    case .tagInfo(let tagItem):
                        guard let tempCell = tableView.dequeueReusableCell(withIdentifier: DictTagTableViewCell.identifier) as? DictTagTableViewCell else { return UITableViewCell() }
                        tempCell.didTapCell = { [weak self] name in
                            self?.viewModel.tappedCellName
                                .accept(name)
                            
                        }
                        let type = self?.viewModel.selectedTab.value == 0 ? DictType.map : DictType.quest
                        tempCell.bind(items: tagItem, descriptionType: type)
                        cell = tempCell
                    default:
                        return UITableViewCell()
                    }
                }
                cell.selectionStyle = .none
                return cell
            }
        )
        
        viewModel.sectionData
            .bind(to: dictNPCTableView.rx.items(dataSource: dataSource))
            .disposed(by: viewModel.disposeBag)
        
        viewModel.tappedCellName
            .withUnretained(self)
            .subscribe(onNext: { owner, name in
                switch owner.viewModel.selectedTab.value {
                case 0:
                    let db = SqliteManager()
                    db.searchData(dataName: name) { (item: [DictMap]) in
                        if item.isEmpty {
                            AlertManager.showAlert(vc: owner, type: .red, title: nil, description: "해당 컨텐츠에 표기할 내용이 없어요.", location: .center)
                        } else {
                            guard let name = item.first?.name else { return }
                            let vm = DictMapViewModel(selectedName: name)
                            let vc = DictMapViewController(viewModel: vm)
                            owner.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                case 1:
                    let db = SqliteManager()
                    db.searchData(dataName: name) { (item: [DictQuest]) in
                        if item.isEmpty {
                            AlertManager.showAlert(vc: owner, type: .red, title: nil, description: "해당 컨텐츠에 표기할 내용이 없어요.", location: .center)
                        } else {
                            guard let name = item.first?.name else { return }
                            let vm = DictQuestViewModel(selectedName: name)
                            let vc = DictQuestViewController(viewModel: vm)
                            owner.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                default:
                    break
                }
            })
            .disposed(by: viewModel.disposeBag)
        
        viewModel.selectedTab
            .withUnretained(self)
            .subscribe(onNext: { owner, selectedTab in
                switch selectedTab {
                case 0:
                    owner.viewModel.fetchTagMaps()
                case 1:
                    owner.viewModel.fetchTagQuests()
                default:
                    break
                }
            })
            .disposed(by: viewModel.disposeBag)
    }
}

extension DictNPCViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView()
            view.backgroundColor = .white
            let separator = UIView()
            separator.backgroundColor = .semanticColor.bolder.secondary
            view.addSubview(separator)
            separator.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview().offset(1)
                $0.height.equalTo(1)
            }
            view.addSubview(infoMenuCollectionView)
            infoMenuCollectionView.snp.makeConstraints {
                $0.width.equalTo(75 * 2 + Constants.spacings.xl_3 * 2)
                $0.height.equalTo(48)
                $0.center.equalToSuperview()
            }
            return view
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 40
        } else {
            return 0
        }
    }
}

extension DictNPCViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tabMenus.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DictSearchMenuCell.identifier, for: indexPath) as? DictSearchMenuCell else { return UICollectionViewCell() }
        cell.bind(text: viewModel.tabMenus[indexPath.row])
        if indexPath.item == viewModel.fetchMenuIndex() {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.setMenuIndex(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        for index in viewModel.emptyData {
            if indexPath.row == index {
                AlertManager.showAlert(vc: self, type: .red, title: nil, description: "해당 컨텐츠에 표기할 내용이 없어요.", location: .center)
                return false
            }
        }
        return true
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 75.0
        let height = 40.0
        return CGSize(width: width, height: height)
    }
}

extension DictNPCViewController: DictMainInfoCellDelegate {
    func didTapExpandButton() {
        dictNPCTableView.reloadData()
    }
}
