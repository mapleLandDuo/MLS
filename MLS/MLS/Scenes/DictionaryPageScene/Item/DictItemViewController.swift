//
//  DictItemViewController.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/01.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit

class DictItemViewController: BasicController {
    // MARK: Properties

    let viewModel: DictItemViewModel

    // MARK: Components

    private let dictItemTableView: UITableView = {
        let view = UITableView()
        view.register(DictMainInfoCell.self, forCellReuseIdentifier: DictMainInfoCell.identifier)
        view.register(DictDetailContentsCell.self, forCellReuseIdentifier: DictDetailContentsCell.identifier)
        view.register(DictItemDropCell.self, forCellReuseIdentifier: DictItemDropCell.identifier)
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

    init(viewModel: DictItemViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Life Cycle
extension DictItemViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
}

// MARK: SetUp
private extension DictItemViewController {
    func setUp() {
        dictItemTableView.delegate = self

        infoMenuCollectionView.delegate = self
        infoMenuCollectionView.dataSource = self

        setUpConstraints()
        setUpNavigation(title: "상세정보")
    }

    func setUpConstraints() {
        view.addSubview(dictItemTableView)

        dictItemTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: Bind
private extension DictItemViewController {
    func bind() {
        let dataSource = RxTableViewSectionedReloadDataSource<Section>(
            configureCell: { _, tableView, indexPath, item in
                var cell = UITableViewCell()
                if indexPath.section == 0 {
                    switch item {
                    case .mainInfo(let mainItem):
                        guard let tempCell = tableView.dequeueReusableCell(withIdentifier: DictMainInfoCell.identifier, for: indexPath) as? DictMainInfoCell else { return UITableViewCell() }
                        tempCell.contentView.isUserInteractionEnabled = false
                        tempCell.bind(item: mainItem)
                        tempCell.delegate = self
                        cell = tempCell
                    default:
                        break
                    }
                } else {
                    switch item {
                    case .detailInfo(let detailItem):
                        guard let tempCell = tableView.dequeueReusableCell(withIdentifier: DictDetailContentsCell.identifier, for: indexPath) as? DictDetailContentsCell else { return UITableViewCell() }
                        tempCell.bind(items: detailItem)
                        cell = tempCell
                    case .dropItem(let dictDropItem):
                        guard let tempCell = tableView.dequeueReusableCell(withIdentifier: DictItemDropCell.identifier, for: indexPath) as? DictItemDropCell else { return UITableViewCell() }
                        tempCell.contentView.isUserInteractionEnabled = false
                        tempCell.bind(items: dictDropItem)
                        tempCell.didTapCell = { [weak self] name in
                            self?.viewModel.tappedCellName.accept(name)
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
            .bind(to: dictItemTableView.rx.items(dataSource: dataSource))
            .disposed(by: viewModel.disposeBag)
        
        viewModel.tappedCellName
            .withUnretained(self)
            .subscribe(onNext: { owner, name in
                let vm = DictMonsterViewModel(selectedName: name)
                let vc = DictMonsterViewController(viewModel: vm)
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: viewModel.disposeBag)

        viewModel.selectedTab
            .withUnretained(self)
            .subscribe(onNext: { owner, selectedTab in
                switch selectedTab {
                case 0:
                    owner.viewModel.fetchDefaultInfos()
                case 1:
                    owner.viewModel.fetchDetailInfos()
                case 2:
                    owner.viewModel.fetchDropInfos()
                default:
                    break
                }
            })
            .disposed(by: viewModel.disposeBag)
    }
}

extension DictItemViewController: UITableViewDelegate {
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

extension DictItemViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
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
        let width = Double((Constants.screenWidth - Constants.spacings.xl_3 * 2 - Constants.spacings.xl * 2) / 3)
        let height = 40.0
        return CGSize(width: width, height: height)
    }
}

extension DictItemViewController: DictMainInfoCellDelegate {
    func didTapExpandButton() {
        dictItemTableView.reloadData()
    }
}
