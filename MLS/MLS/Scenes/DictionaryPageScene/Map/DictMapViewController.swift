//
//  DictMapViewController.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/02.
//

import UIKit

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
        dictMapTableView.dataSource = self

        infoMenuCollectionView.delegate = self
        infoMenuCollectionView.dataSource = self

        viewModel.fetchMap()

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
        viewModel.selectedMap.bind { [weak self] _ in
            self?.viewModel.fetchApearMonsters {
                self?.viewModel.fetchApearNPCs {
                    self?.dictMapTableView.reloadData()
                }
            }
        }

        viewModel.selectedTab.bind { [weak self] _ in
            self?.dictMapTableView.reloadData()
        }
    }
}

extension DictMapViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let selectedTab = viewModel.selectedTab.value else { return UITableViewCell() }
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DictMainInfoCell.identifier) as? DictMainInfoCell,
                  let item = viewModel.selectedMap.value else { return UITableViewCell() }
            cell.delegate = self
            cell.bind(item: item)
            return cell
        } else {
            switch selectedTab {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DictMapTableViewCell.identifier) as? DictMapTableViewCell else { return UITableViewCell() }
                cell.delegate = self
                cell.isUserInteractionEnabled = true
                cell.contentView.isUserInteractionEnabled = false
                cell.selectionStyle = .none
                cell.bind(items: viewModel.apearMonsterContents, type: .monster)
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DictMapTableViewCell.identifier) as? DictMapTableViewCell else { return UITableViewCell() }
                cell.delegate = self
                cell.isUserInteractionEnabled = true
                cell.contentView.isUserInteractionEnabled = false
                cell.selectionStyle = .none
                cell.bind(items: viewModel.apearNpcContents, type: .npc)
                return cell
            default:
                return UITableViewCell()
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

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

extension DictMapViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
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
        let contents = indexPath.row == 0 ? viewModel.apearMonsterContents : viewModel.apearNpcContents
        if contents.isEmpty {
            AlertManager.showAlert(vc: self, type: .red, title: nil, description: "해당 컨텐츠에 표기할 내용이 없어요.", location: .center)
            return false
        }
        return true
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 75.0
        let height = 40.0
        return CGSize(width: width, height: height)
    }
}

extension DictMapViewController: DictMapTableViewCellDelegate {
    func didTapMapTableCell(title: String) {
        switch viewModel.selectedTab.value {
        case 0:
            let vm = DictMonsterViewModel(selectedName: title)
            let vc = DictMonsterViewController(viewModel: vm)
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vm = DictNPCViewModel(selectedName: title)
            let vc = DictNPCViewController(viewModel: vm)
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

extension DictMapViewController: DictMainInfoCellDelegate {
    func didTapExpandButton() {
        dictMapTableView.reloadData()
    }
}
