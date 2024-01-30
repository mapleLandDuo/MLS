//
//  DictionaryMainViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 1/25/24.
//

import UIKit

import SnapKit

class DictionaryMainViewController: BasicController {
    // MARK: Components

    private let viewModel: DictionaryMainViewModel

    private let mainTableView = UITableView(frame: .zero, style: .grouped)

    private let itemSearchBar = UISearchBar()

    private let monsterSearchBar = UISearchBar()

    init(viewModel: DictionaryMainViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DictionaryMainViewController {
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

private extension DictionaryMainViewController {
    // MARK: Setup

    func setUp() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(ItemTableViewCell.self, forCellReuseIdentifier: ItemTableViewCell.identifier)

        itemSearchBar.delegate = self
        monsterSearchBar.delegate = self

        setUpConstraints()
    }

    func setUpConstraints() {
        view.addSubview(mainTableView)

        mainTableView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
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
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier, for: indexPath) as? ItemTableViewCell else { return UITableViewCell() }
            cell.bind(itemMenus: viewModel.getItemMenu())
            return cell
        default:
            let cell = UITableViewCell()
            let item = viewModel.getMonsterMenu()[indexPath.row]
            cell.textLabel?.text = "LV. \(item) 몬스터"
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        if section == 0 {
            headerView.addSubview(itemSearchBar)

            itemSearchBar.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }

            itemSearchBar.placeholder = "아이템을 검색하세요."
        } else {
            headerView.addSubview(monsterSearchBar)

            monsterSearchBar.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }

            monsterSearchBar.placeholder = "몬스터를 검색하세요."
        }

        return headerView
    }
}

extension DictionaryMainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        if searchBar == itemSearchBar {
            viewModel.searchItem(name: text) { [weak self] item in
                let viewModel = DictionarySearchViewModel(type: .item)
                viewModel.item.value = item
                let vc = DictionarySearchViewController(viewModel: viewModel)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        } else if searchBar == monsterSearchBar {
            viewModel.searchMonster(name: text) { [weak self] item in
                let viewModel = DictionarySearchViewModel(type: .monster)
                viewModel.monster.value = item
                let vc = DictionarySearchViewController(viewModel: viewModel)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        searchBar.resignFirstResponder()
    }
}
