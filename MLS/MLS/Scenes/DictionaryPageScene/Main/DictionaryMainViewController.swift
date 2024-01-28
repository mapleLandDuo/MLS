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

    private let mainTableView = UITableView()

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
}
