//
//  DictQuestViewController.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/03.
//

import UIKit

import RxCocoa
import RxDataSources
import SnapKit

class DictQuestViewController: BasicController {
    // MARK: Properties

    let viewModel: DictQuestViewModel

    // MARK: Components

    private let dictQuestTableView: UITableView = {
        let view = UITableView()
        view.register(DictMainInfoCell.self, forCellReuseIdentifier: DictMainInfoCell.identifier)
        view.register(DictDetailContentsCell.self, forCellReuseIdentifier: DictDetailContentsCell.identifier)
        view.register(DictMonsterDropCell.self, forCellReuseIdentifier: DictMonsterDropCell.identifier)
        view.register(DictQuestOrderCell.self, forCellReuseIdentifier: DictQuestOrderCell.identifier)
        view.separatorStyle = .none
        return view
    }()

    private let infoMenuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 0, left: Constants.spacings.xl, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Constants.spacings.xl_2
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.register(DictSearchMenuCell.self, forCellWithReuseIdentifier: DictSearchMenuCell.identifier)
        return view
    }()

    init(viewModel: DictQuestViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Life Cycle
extension DictQuestViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
}

// MARK: SetUp
private extension DictQuestViewController {
    func setUp() {
        dictQuestTableView.delegate = self
        infoMenuCollectionView.delegate = self

        setUpConstraints()
        setUpNavigation(title: "상세정보")
    }

    func setUpConstraints() {
        view.addSubview(dictQuestTableView)

        dictQuestTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: Bind
private extension DictQuestViewController {
    func bind() {
        // MARK: Bind tableView
        let dataSource = RxTableViewSectionedReloadDataSource<Section>(
            configureCell: { [weak self] _, tableView, indexPath, item in
                var cell = UITableViewCell()
                if indexPath.section == 0 {
                    switch item {
                    case .mainInfo(let mainItem):
                        guard let tempCell = tableView.dequeueReusableCell(withIdentifier: DictMainInfoCell.identifier, for: indexPath) as? DictMainInfoCell else { return UITableViewCell() }
                        tempCell.tappedExpandButton = { [weak self] isTapped in
                            self?.viewModel.tappedExpandButton.accept(isTapped)
                        }
                        tempCell.bind(item: mainItem)
                        cell = tempCell
                    default:
                        break
                    }
                } else if indexPath.section == 1 {
                    switch item {
                    case .detailInfo(let detailInfo):
                        guard let tempCell = tableView.dequeueReusableCell(withIdentifier: DictDetailContentsCell.identifier, for: indexPath) as? DictDetailContentsCell else { return UITableViewCell() }
                        tempCell.bind(items: detailInfo)
                        cell = tempCell
                    case .mainInfo(let questInfo):
                        guard let tempCell = tableView.dequeueReusableCell(withIdentifier: DictQuestOrderCell.identifier, for: indexPath) as? DictQuestOrderCell,
                              let quest = questInfo as? DictQuest else { return UITableViewCell() }
                        tempCell.tappedCell = { [weak self] name in
                            self?.viewModel.tappedCellQuest.accept(name)
                        }
                        tempCell.bind(quest: quest)
                        cell = tempCell
                    default:
                        break
                    }
                } else {
                    switch item {
                    case .dropItem(let dropInfo):
                        guard let tempCell = tableView.dequeueReusableCell(withIdentifier: DictMonsterDropCell.identifier, for: indexPath) as? DictMonsterDropCell else { return UITableViewCell() }
                        tempCell.isUserInteractionEnabled = true
                        tempCell.contentView.isUserInteractionEnabled = false
                        switch self?.viewModel.selectedTab.value {
                        case 0:
                            tempCell.bind(items: dropInfo, type: "정보 완료 조건")
                        default:
                            tempCell.bind(items: dropInfo, type: "퀘스트 보상")
                        }
                        tempCell.tappedCell = { [weak self] name, type in
                            self?.viewModel.tappedCellData.accept((name, type))
                        }
                        cell = tempCell
                    default:
                        break
                    }
                }
                cell.selectionStyle = .none
                return cell
            }
        )

        viewModel.sectionData
            .bind(to: dictQuestTableView.rx.items(dataSource: dataSource))
            .disposed(by: viewModel.disposeBag)

        viewModel.tappedCellData
            .withUnretained(self)
            .subscribe(onNext: { owner, data in
                let name = data.0
                let type = data.1
                switch owner.viewModel.selectedTab.value {
                case 0:
                    if type == .item {
                        let vm = DictItemViewModel(selectedName: name)
                        let vc = DictItemViewController(viewModel: vm)
                        owner.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let vm = DictMonsterViewModel(selectedName: name)
                        let vc = DictMonsterViewController(viewModel: vm)
                        owner.navigationController?.pushViewController(vc, animated: true)
                    }
                case 1:
                    let vm = DictItemViewModel(selectedName: name)
                    let vc = DictItemViewController(viewModel: vm)
                    owner.navigationController?.pushViewController(vc, animated: true)

                default:
                    break
                }
            })
            .disposed(by: viewModel.disposeBag)

        viewModel.tappedCellQuest
            .withUnretained(self)
            .subscribe(onNext: { owner, name in
                if name != owner.viewModel.selectedQuest.value?.currentQuest {
                    let vm = DictQuestViewModel(selectedName: name.trimmingCharacters(in: .whitespaces))
                    let vc = DictQuestViewController(viewModel: vm)
                    owner.navigationController?.pushViewController(vc, animated: true)
                }
            })
            .disposed(by: viewModel.disposeBag)
        viewModel.selectedTab
            .withUnretained(self)
            .subscribe(onNext: { owner, selectedTab in
                switch selectedTab {
                case 0:
                    owner.viewModel.fetchDefaultInfos()
                    owner.viewModel.fetchCompleteInfos()
                case 1:
                    owner.viewModel.fetchRewardInfos()
                    owner.viewModel.fetchRewardTableContents()
                case 2:
                    owner.viewModel.fetchQuestInfos()
                default:
                    break
                }
            })
            .disposed(by: viewModel.disposeBag)
        
        viewModel.tappedExpandButton
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dictQuestTableView.reloadData()
            })
            .disposed(by: viewModel.disposeBag)
        
        // MARK: Bind collectionView
        viewModel.tabMenus
            .bind(to: infoMenuCollectionView.rx.items(cellIdentifier: DictSearchMenuCell.identifier, cellType: DictSearchMenuCell.self)) { _, text, cell in
                cell.bind(text: text)
            }
            .disposed(by: viewModel.disposeBag)

        infoMenuCollectionView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.selectedTab)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.selectedTab
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }

                let indexPath = IndexPath(item: index, section: 0)
                self.infoMenuCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            })
            .disposed(by: viewModel.disposeBag)
    }
}

extension DictQuestViewController: UITableViewDelegate {
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
                $0.width.equalTo(Constants.screenWidth)
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

extension DictQuestViewController: UICollectionViewDelegateFlowLayout {
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
        let width = Double((Constants.screenWidth - Constants.spacings.xl_2 * 2 - Constants.spacings.xl * 2) / 3)
        let height = 40.0
        return CGSize(width: width, height: height)
    }
}
