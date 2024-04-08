//
//  DictMapViewController.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/02.
//

import UIKit

import RxCocoa
import RxDataSources
import SnapKit

class DictMapViewController: BasicController {
    // MARK: Properties

    let viewModel: DictMapViewModel

    // MARK: Components

    private let dictMapTableView: UITableView = {
        let view = UITableView()
        view.register(DictMainInfoCell.self, forCellReuseIdentifier: DictMainInfoCell.identifier)
        view.register(DictMapTableViewCell.self, forCellReuseIdentifier: DictMapTableViewCell.identifier)
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

    init(viewModel: DictMapViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Life Cycle
extension DictMapViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
}

// MARK: SetUp
private extension DictMapViewController {
    func setUp() {
        dictMapTableView.delegate = self
        infoMenuCollectionView.delegate = self

        setUpConstraints()
        setUpNavigation(title: "상세정보")
    }

    func setUpConstraints() {
        view.addSubview(dictMapTableView)

        dictMapTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: Bind
extension DictMapViewController {
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
                } else {
                    switch item {
                    case .dropItem(let dropItem):
                        guard let tempCell = tableView.dequeueReusableCell(withIdentifier: DictMapTableViewCell.identifier) as? DictMapTableViewCell else { return UITableViewCell() }
                        tempCell.tappedCell = { [weak self] name in
                            self?.viewModel.tappedCellName
                                .accept(name)
                        }
                        let type = self?.viewModel.selectedTab.value == 0 ? DictType.monster : DictType.npc
                        tempCell.bind(items: dropItem, type: type)
                        cell = tempCell
                    default:
                        return UITableViewCell()
                    }
                }
                cell.isUserInteractionEnabled = true
                cell.contentView.isUserInteractionEnabled = false
                cell.selectionStyle = .none
                return cell
            }
        )
        
        viewModel.sectionData
            .bind(to: dictMapTableView.rx.items(dataSource: dataSource))
            .disposed(by: viewModel.disposeBag)

        viewModel.tappedCellName
            .withUnretained(self)
            .subscribe(onNext: { owner, name in
                switch owner.viewModel.selectedTab.value {
                case 0:
                    let vm = DictMonsterViewModel(selectedName: name)
                    let vc = DictMonsterViewController(viewModel: vm)
                    owner.navigationController?.pushViewController(vc, animated: true)
                case 1:
                    let vm = DictNPCViewModel(selectedName: name)
                    let vc = DictNPCViewController(viewModel: vm)
                    owner.navigationController?.pushViewController(vc, animated: true)
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
                    owner.viewModel.fetchApearMonsters()
                case 1:
                    owner.viewModel.fetchApearNPCs()
                default:
                    break
                }
            })
            .disposed(by: viewModel.disposeBag)
        
        viewModel.tappedExpandButton
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dictMapTableView.reloadData()
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

extension DictMapViewController: UITableViewDelegate {
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

extension DictMapViewController: UICollectionViewDelegateFlowLayout {
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
