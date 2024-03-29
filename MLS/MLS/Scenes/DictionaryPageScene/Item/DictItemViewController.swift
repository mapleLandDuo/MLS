//
//  DictItemViewController.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/01.
//

import UIKit

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
        dictItemTableView.dataSource = self
        
        infoMenuCollectionView.delegate = self
        infoMenuCollectionView.dataSource = self

        viewModel.fetchItem()

        setUpConstraints()
        setUpNavigation()
    }

    func setUpConstraints() {
        view.addSubview(dictItemTableView)

        dictItemTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: Bind
extension DictItemViewController {
    func bind() {
        viewModel.selectedItem.bind { [weak self] _ in
            self?.viewModel.fetchDropInfos {
                self?.dictItemTableView.reloadData()
            }
        }
        
        viewModel.selectedTab.bind { [weak self] _ in
            self?.dictItemTableView.reloadData()
        }
    }
}

// MARK: Methods
extension DictItemViewController {
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

extension DictItemViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let selectedTab = viewModel.selectedTab.value else { return UITableViewCell() }
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DictMainInfoCell.identifier) as? DictMainInfoCell,
                  let item = viewModel.selectedItem.value else { return UITableViewCell() }
            cell.delegate = self
            cell.bind(item: item)
            cell.selectionStyle = .none
            return cell
        } else {
            switch selectedTab {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DictDetailContentsCell.identifier) as? DictDetailContentsCell,
                      let items = viewModel.fetchDefaultInfos() else { return UITableViewCell() }
                cell.bind(items: items)
                cell.selectionStyle = .none
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DictDetailContentsCell.identifier) as? DictDetailContentsCell,
                      let items = viewModel.fetchDetailInfos() else { return UITableViewCell() }
                cell.bind(items: items)
                cell.selectionStyle = .none
                return cell
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DictItemDropCell.identifier) as? DictItemDropCell else { return UITableViewCell() }
                cell.delegate = self
                cell.isUserInteractionEnabled = true
                cell.contentView.isUserInteractionEnabled = false
                cell.bind(items: viewModel.dropTableContents)
                cell.selectionStyle = .none
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
        if indexPath.row == 2 && viewModel.dropTableContents.isEmpty {
            AlertManager.showAlert(vc: self, type: .red, title: nil, description: "해당 컨텐츠에 표기할 내용이 없어요.", location: .center)
            return false
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Double((Constants.screenWidth - Constants.spacings.xl_3 * 2 - Constants.spacings.xl * 2) / 3)
        let height = 40.0
        return CGSize(width: width, height: height)
    }
}

extension DictItemViewController: DictItemDropCellDelegate {
    func didTapItemDropCell(title: String) {
        let vm = DictMonsterViewModel(selectedName: title)
        let vc = DictMonsterViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DictItemViewController: DictMainInfoCellDelegate {
    func didTapExpandButton() {
        dictItemTableView.reloadData()
    }
}
