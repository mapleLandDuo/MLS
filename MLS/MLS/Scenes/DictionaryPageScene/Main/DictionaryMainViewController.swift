//
//  DictionaryMainViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 1/25/24.
//

import UIKit

import SnapKit

class DictionaryMainViewController: BasicController {
    // MARK: - Properties

    private let viewModel: DictionaryMainViewModel
    
    // MARK: Components

    private let mainTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = .white
        view.separatorStyle = .none
        return view
    }()

    private let itemSearchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.backgroundImage = UIImage()
        bar.placeholder = "아이템을 검색하세요."
        return bar
    }()

    private let monsterSearchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.backgroundImage = UIImage()
        bar.placeholder = "몬스터를 검색하세요."
        return bar
    }()

    init(viewModel: DictionaryMainViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension DictionaryMainViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    override func viewWillAppear(_ animated: Bool) {
        itemSearchBar.text = ""
        monsterSearchBar.text = ""
    }
}

// MARK: Setup
private extension DictionaryMainViewController {

    func setUp() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(IconDescriptionTableViewCell.self, forCellReuseIdentifier: IconDescriptionTableViewCell.identifier)
        mainTableView.register(DictionaryGraySeparatorOneLineCell.self, forCellReuseIdentifier: DictionaryGraySeparatorOneLineCell.identifier)

        itemSearchBar.delegate = self
        monsterSearchBar.delegate = self

        setUpConstraints()
    }

    func setUpConstraints() {
        view.addSubview(mainTableView)

        mainTableView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
}

extension DictionaryMainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return viewModel.getMonsterMenuCount()
        default:
            return viewModel.getItemMenuCount()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: IconDescriptionTableViewCell.identifier, for: indexPath) as? IconDescriptionTableViewCell else { return UITableViewCell() }
            let item = viewModel.getItemMenu()[indexPath.row]
            cell.delegate = self
            cell.bind(data: item)
            cell.selectionStyle = .none
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryGraySeparatorOneLineCell.identifier, for: indexPath) as? DictionaryGraySeparatorOneLineCell else { return UITableViewCell() }
            let item = viewModel.getMonsterMenu()[indexPath.row]
            cell.bind(name: "LV. \(item)", description: "몬스터")
            cell.selectionStyle = .none
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return makeHearderView(searchBar: itemSearchBar, title: "아이템 검색", description: "직업별 아이템")
        } else {
            return makeHearderView(searchBar: monsterSearchBar, title: "몬스터 검색", description: "레벨별 몬스터")
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            var minLevel = 151
            var maxLevel = 1000

            if viewModel.getMonsterMenu()[indexPath.row] != "etc" {
                minLevel = (indexPath.row * 10 + 1)
                maxLevel = (indexPath.row + 1) * 10
            }

            viewModel.loadMonsterByLevel(minLevel: minLevel, maxLevel: maxLevel) { [weak self] monsters in
                if monsters.isEmpty {
                    AlertMaker.showAlertAction1(vc: self, message: "해당 레벨에 맞는 몬스터가 없습니다!")
                    return
                }

                let vm = DictionarySearchViewModel(type: .monster)
                vm.monsterList.value = monsters
                let vc = DictionarySearchViewController(viewModel: vm)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            return
        }
    }

    func makeHearderView(searchBar: UISearchBar, title: String, description: String) -> UIView {
        let headerView = UIView()
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = title
            label.font = Typography.title2.font
            return label
        }()
        let titleSeparator: UIView = {
            let view = UIView()
            view.backgroundColor = .systemOrange
            return view
        }()
        let descriptionLabel: UILabel = {
            let label = UILabel()
            label.text = description
            label.font = Typography.title2.font
            return label
        }()
        let bottomSeparator: UIView = {
            let view = UIView()
            view.backgroundColor = .systemOrange
            return view
        }()

        headerView.addSubview(searchBar)
        headerView.addSubview(titleLabel)
        headerView.addSubview(titleSeparator)
        headerView.addSubview(descriptionLabel)
        headerView.addSubview(bottomSeparator)
        
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(7)
            $0.height.equalTo(Constants.defaults.blockHeight)
        }

        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(searchBar.snp.centerY)
            $0.leading.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.trailing.equalTo(searchBar.snp.leading)
        }

        titleSeparator.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.height.equalTo(1)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleSeparator.snp.bottom).offset(Constants.defaults.vertical)
            $0.leading.equalToSuperview().inset(Constants.defaults.horizontal)
        }

        bottomSeparator.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
        return headerView
    }
}

extension DictionaryMainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        IndicatorMaker.showLoading()
        if searchBar == itemSearchBar {
            viewModel.searchItem(name: text) { [weak self] item in
                IndicatorMaker.hideLoading()
                guard let item = item else {
                    AlertMaker.showAlertAction1(title: "검색 결과가 없습니다.")
                    return
                }
                let viewModel = DictionarySearchViewModel(type: .item)
                viewModel.itemList.value = item
                let vc = DictionarySearchViewController(viewModel: viewModel)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        } else if searchBar == monsterSearchBar {
            viewModel.searchMonster(name: text) { [weak self] item in
                IndicatorMaker.hideLoading()
                guard let item = item else {
                    AlertMaker.showAlertAction1(title: "검색 결과가 없습니다.")
                    return
                }
                let viewModel = DictionarySearchViewModel(type: .monster)
                viewModel.monsterList.value = item
                let vc = DictionarySearchViewController(viewModel: viewModel)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        searchBar.resignFirstResponder()
    }
}

extension DictionaryMainViewController: IconDescriptionTableViewCellDelegate {
    func tapLeftButton(data: [ItemMenu]) {
        guard let roll = data.first?.title.rawValue else { return }
        viewModel.loadItemByRoll(roll: roll) { [weak self] items in
            let vm = DictionarySearchViewModel(type: .item)
            vm.itemList.value = items
            let vc = DictionarySearchViewController(viewModel: vm)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tapRightButton(data: [ItemMenu]) {
        guard let roll = data.last?.title.rawValue else { return }
        viewModel.loadItemByRoll(roll: roll) { [weak self] items in
            let vm = DictionarySearchViewModel(type: .item)
            vm.itemList.value = items
            let vc = DictionarySearchViewController(viewModel: vm)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
