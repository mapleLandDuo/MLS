//
//  DictionaryItemViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 1/28/24.
//

import UIKit

import SnapKit

class DictionaryItemViewController: BasicController {
    // MARK: - Properties

    let viewModel: DictionaryItemViewModel

    // MARK: - Components

    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = .white
        view.separatorStyle = .none
        return view
    }()

    init(viewModel: DictionaryItemViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension DictionaryItemViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

// MARK: - SetUp
private extension DictionaryItemViewController {

    func setUp() {
        setUpConstraints()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DictionaryNameImageCell.self, forCellReuseIdentifier: DictionaryNameImageCell.identifier)
        tableView.register(DictionaryItemDefaultCell.self, forCellReuseIdentifier: DictionaryItemDefaultCell.identifier)
        tableView.register(DictionaryGraySeparatorOneLineCell.self, forCellReuseIdentifier: DictionaryGraySeparatorOneLineCell.identifier)
        tableView.register(DictionaryGraySeparatorDescriptionCell.self, forCellReuseIdentifier: DictionaryGraySeparatorDescriptionCell.identifier)
    }

    func setUpConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { 
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension DictionaryItemViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            let item = viewModel.fetchItem()
            let tempArray = [
                "description": item.description,
                "str": item.str,
                "dex": item.dex,
                "luk": item.luk,
                "int": item.int
            ]
            let datas = tempArray.filter { $0.value != nil }
            return datas.count + 1
        case 2:
            return viewModel.fetchItem().detailDescription.count
        case 3:
            return viewModel.fetchItem().dropTable.count
        default:
            return 1
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryNameImageCell.identifier, for: indexPath) as? DictionaryNameImageCell else { return UITableViewCell() }
            cell.bind(item: viewModel.fetchItem())
            cell.selectionStyle = .none
            return cell
        case 1:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryItemDefaultCell.identifier, for: indexPath) as? DictionaryItemDefaultCell else { return UITableViewCell() }
                cell.bind(item: viewModel.fetchItem())
                cell.selectionStyle = .none
                return cell
            } else {
                let datas = viewModel.fetchDefaultInfoArray()
                if datas[indexPath.row - 1].name == "설명" {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryGraySeparatorDescriptionCell.identifier, for: indexPath) as? DictionaryGraySeparatorDescriptionCell else { return UITableViewCell() }
                    cell.bind(data: datas[indexPath.row - 1])
                    cell.selectionStyle = .none
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryGraySeparatorOneLineCell.identifier, for: indexPath) as? DictionaryGraySeparatorOneLineCell else { return UITableViewCell() }
                    cell.bind(data: datas[indexPath.row - 1])
                    cell.selectionStyle = .none
                    return cell
                }
            }
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryGraySeparatorOneLineCell.identifier, for: indexPath) as? DictionaryGraySeparatorOneLineCell else { return UITableViewCell() }
            let datas = viewModel.fetchDetailInfoArray()
            cell.bind(data: datas[indexPath.row])
            cell.selectionStyle = .none
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryGraySeparatorOneLineCell.identifier, for: indexPath) as? DictionaryGraySeparatorOneLineCell else { return UITableViewCell() }
            cell.bind(data: viewModel.fetchItem().dropTable[indexPath.row])
            cell.selectionStyle = .none
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryGraySeparatorOneLineCell.identifier, for: indexPath) as? DictionaryGraySeparatorOneLineCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 3:
            let monsterName = viewModel.fetchItem().dropTable[indexPath.row].name
            IndicatorMaker.showLoading()
            FirebaseManager.firebaseManager.fetchMonsters(monsterName: monsterName) { item in
                guard let item = item else { return }
                IndicatorMaker.hideLoading()
                let vc = DictionaryMonsterViewController(viewModel: DictionaryMonsterViewModel(item: item))
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            return
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        case 1:
            return makeHeaderView(title: "기본 정보")
        case 2:
            return makeHeaderView(title: "세부 정보")
        case 3:
            return makeHeaderView(title: "드랍 정보")
        default:
            return makeHeaderView(title: "temp")
        }
    }

    func makeHeaderView(title: String) -> UIView {
        let view: UIView = {
            let view = UIView()
            return view
        }()
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = title
            label.font = Typography.title2.font
            return label
        }()
        let separatorView: UIView = {
            let view = UIView()
            view.backgroundColor = .systemOrange
            return view
        }()
        view.addSubview(titleLabel)
        view.addSubview(separatorView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(Constants.defaults.horizontal)
        }

        separatorView.snp.makeConstraints { 
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }

        return view
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            navigationItem.title = viewModel.item.name
        } else {
            navigationItem.title = nil
        }
    }
}
