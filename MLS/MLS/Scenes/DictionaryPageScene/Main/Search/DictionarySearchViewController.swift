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
    }
}

private extension DictionarySearchViewController {
    // MARK: Setup

    func setUp() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
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
    }
}

extension DictionarySearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.type {
        case .item:
            print("itemCount = \(viewModel.getItemListCount())")
            return viewModel.getItemListCount()
        case .monster:
            print("monsterCount = \(viewModel.getMonsterListCount())")
            return viewModel.getMonsterListCount()
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionarySearchCell.identifier, for: indexPath) as? DictionarySearchCell else { return UITableViewCell() }
        switch viewModel.type {
        case .item:
            guard let item = viewModel.itemList.value?[indexPath.row] else { return UITableViewCell() }
//            cell.bind(imageUrl: item?., title: item.name, level: item.level)
        case .monster:
            guard let item = viewModel.monsterList.value?[indexPath.row] else { return UITableViewCell() }
//            cell.bind(imageUrl: item?., title: item?.name, level: item?.level)
        }
        return cell
    }
}
