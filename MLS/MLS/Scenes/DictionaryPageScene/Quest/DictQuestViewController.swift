//
//  DictQuestViewController.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/03.
//

import UIKit

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
        dictQuestTableView.dataSource = self

        infoMenuCollectionView.delegate = self
        infoMenuCollectionView.dataSource = self

        viewModel.fetchQuest()

        setUpConstraints()
        setUpNavigation()
    }

    func setUpConstraints() {
        view.addSubview(dictQuestTableView)

        dictQuestTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: Bind
extension DictQuestViewController {
    func bind() {
        viewModel.selectedQuest.bind { [weak self] _ in
            self?.viewModel.fetchCompleteInfos {
                self?.viewModel.fetchRewardInfos {
                    self?.dictQuestTableView.reloadData()
                }
            }
        }

        viewModel.selectedTab.bind { [weak self] _ in
            self?.dictQuestTableView.reloadData()
        }
    }
}

// MARK: Methods
extension DictQuestViewController {
    func setUpNavigation() {
        let spacer = UIBarButtonItem()
        let image = UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysTemplate)
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTapBackButton))
        let titleLabel = UILabel()
        titleLabel.text = "상세정보"
        titleLabel.font = .customFont(fontSize: .heading_sm, fontType: .semiBold)
        titleLabel.textColor = .themeColor(color: .base, value: .value_black)
        navigationItem.titleView = titleLabel

        backButton.tintColor = .themeColor(color: .base, value: .value_black)
        navigationItem.leftBarButtonItems = [spacer, backButton]
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.shadowImage = nil
    }

    @objc
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension DictQuestViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            if viewModel.selectedTab.value != 2 {
                return 1
            } else {
                return 0
            }
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let selectedTab = viewModel.selectedTab.value else { return UITableViewCell() }
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DictMainInfoCell.identifier) as? DictMainInfoCell,
                  let item = viewModel.selectedQuest.value else { return UITableViewCell() }
            cell.delegate = self
            cell.selectionStyle = .none
            cell.bind(item: item)
            return cell
        } else if indexPath.section == 1 {
            switch selectedTab {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DictDetailContentsCell.identifier) as? DictDetailContentsCell,
                      let items = viewModel.fetchDefaultInfos() else { return UITableViewCell() }
                cell.bind(items: items)
                cell.selectionStyle = .none
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DictDetailContentsCell.identifier) as? DictDetailContentsCell else { return UITableViewCell() }
                cell.bind(items: viewModel.fetchRewardTableContents())
                cell.selectionStyle = .none
                return cell
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DictQuestOrderCell.identifier) as? DictQuestOrderCell,
                      let currentQuest = viewModel.selectedQuest.value?.currentQuest else { return UITableViewCell() }
                cell.delegate = self
                cell.bind(preQuest: viewModel.selectedQuest.value?.preQuest, currentQuest: currentQuest, laterQuest: viewModel.selectedQuest.value?.laterQuest)
                cell.selectionStyle = .none
                return cell
            default:
                return UITableViewCell()
            }
        } else {
            switch selectedTab {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DictMonsterDropCell.identifier) as? DictMonsterDropCell else { return UITableViewCell() }
                cell.delegate = self
                cell.isUserInteractionEnabled = true
                cell.contentView.isUserInteractionEnabled = false
                cell.bind(items: viewModel.completeTableContents, type: "정보 완료 조건")
                cell.selectionStyle = .none
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DictMonsterDropCell.identifier) as? DictMonsterDropCell else { return UITableViewCell() }
                cell.delegate = self
                cell.isUserInteractionEnabled = true
                cell.contentView.isUserInteractionEnabled = false
                cell.bind(items: viewModel.rewardTableContents, type: "퀘스트 보상")
                cell.selectionStyle = .none
                return cell
            default:
                return UITableViewCell()
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView()
            view.addSubview(infoMenuCollectionView)
            infoMenuCollectionView.snp.makeConstraints {
                $0.width.equalTo(Constants.screenWidth)
                $0.height.equalTo(40)
                $0.center.equalToSuperview()
            }

            let separator = UIView()
            separator.backgroundColor = .semanticColor.bolder.secondary
            view.addSubview(separator)
            separator.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview().offset(1)
                $0.height.equalTo(1)
            }
            view.backgroundColor = .themeColor(color: .base, value: .value_white)
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

extension DictQuestViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Double((Constants.screenWidth - Constants.spacings.xl_2 * 2 - Constants.spacings.xl * 2) / 3)
        let height = 40.0
        return CGSize(width: width, height: height)
    }
}

extension DictQuestViewController: DictMonsterDropCellDelegate {
    func didTapDropTableCell(title: String, type: DictType?) {
        switch viewModel.selectedTab.value {
        case 0:
            if type == .item {
                let vm = DictItemViewModel(selectedName: title)
                let vc = DictItemViewController(viewModel: vm)
                navigationController?.pushViewController(vc, animated: true)
            } else {
                let vm = DictMonsterViewModel(selectedName: title)
                let vc = DictMonsterViewController(viewModel: vm)
                navigationController?.pushViewController(vc, animated: true)
            }
        case 1:
            let vm = DictItemViewModel(selectedName: title)
            let vc = DictItemViewController(viewModel: vm)
            navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
        }
    }
}

extension DictQuestViewController: DictQuestOrderCellDelegate {
    func didTapQuestCell(title: String) {
        if title != viewModel.selectedQuest.value?.currentQuest {
            let vm = DictQuestViewModel(selectedName: title)
            let vc = DictQuestViewController(viewModel: vm)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension DictQuestViewController: DictMainInfoCellDelegate {
    func didTapExpandButton() {
        dictQuestTableView.reloadData()
    }
}
