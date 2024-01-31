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
            return viewModel.getItemMenu().count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: IconDescriptionTableViewCell.identifier, for: indexPath) as? IconDescriptionTableViewCell else { return UITableViewCell() }
            let item = viewModel.getItemMenu()[indexPath.row]
            cell.bind(iconUrl: item.image, description: item.title)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryGraySeparatorOneLineCell.identifier, for: indexPath) as? DictionaryGraySeparatorOneLineCell else { return UITableViewCell() }
            let item = viewModel.getMonsterMenu()[indexPath.row]
            cell.bind(name: "LV. \(item)", description: "몬스터")
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
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview().inset(7)
            make.height.equalTo(Constants.defaults.blockHeight)
        }
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(searchBar.snp.centerY)
            make.left.equalToSuperview().inset(Constants.defaults.horizontal)
            make.right.equalTo(searchBar.snp.left)
        }
        headerView.addSubview(titleSeparator)
        titleSeparator.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.height.equalTo(1)
        }
        headerView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleSeparator.snp.bottom).offset(Constants.defaults.vertical)
            make.left.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        headerView.addSubview(bottomSeparator)
        bottomSeparator.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
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
