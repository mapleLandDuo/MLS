//
//  DictionarySearchViewController.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/29.
//

import UIKit

import SnapKit

class DictionarySearchViewController: BasicController {
    // MARK: Properties

    private let viewModel: DictionarySearchViewModel

    // MARK: Components

    private let searchTableView = UITableView()

    init(viewModel: DictionarySearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DictionarySearchViewController {
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
        searchTableView.reloadData()
    }
}

private extension DictionarySearchViewController {
    // MARK: Setup

    func setUp() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(DictionarySearchCell.self, forCellReuseIdentifier: DictionarySearchCell.identifier)

        setUpConstraints()
    }

    func setUpConstraints() {
        view.addSubview(searchTableView)

        searchTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

private extension DictionarySearchViewController {
    // MARK: Bind

    func bind() {
        viewModel.itemList.bind { [weak self] _ in
            self?.searchTableView.reloadData()
        }

        viewModel.monsterList.bind { [weak self] _ in
            self?.searchTableView.reloadData()
        }

//        viewModel.itemList.bind { [weak self] _ in
//            self?.searchTableView.reloadData()
//        }
//
//        viewModel.monsterList.bind { [weak self] _ in
//            self?.searchTableView.reloadData()
//        }
    }
}

extension DictionarySearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.type {
        case .item:
            return viewModel.getItemListCount()
        case .monster:
            return viewModel.getMonsterListCount()

        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionarySearchCell.identifier, for: indexPath) as? DictionarySearchCell else { return UITableViewCell() }
        switch viewModel.type {
        case .item:
            guard let item = viewModel.itemList.value?[indexPath.row],
                  let url = viewModel.getURL()[indexPath.row] else { return UITableViewCell() }
//            guard let item = viewModel.item.value else { return UITableViewCell() }
            cell.bind(imageUrl: url, title: item.name, level: item.level)
        case .monster:
            guard let item = viewModel.monsterList.value?[indexPath.row],
            let url = viewModel.getURL()[indexPath.row] else { return UITableViewCell() }
//            guard let item = viewModel.monster.value else { return UITableViewCell() }
            cell.bind(imageUrl: url, title: item.name, level: String(item.level))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.type {
        case .item:
            guard let item = viewModel.itemList.value?[indexPath.row] else { return }
            let vc = DictionaryItemViewController(viewModel: DictionaryItemViewModel(item: item))
            navigationController?.pushViewController(vc, animated: true)
        case .monster:
            guard let item = viewModel.monsterList.value?[indexPath.row] else { return }
            let vc = DictionaryMonsterViewController(viewModel: DictionaryMonsterViewModel(item: item))
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}
