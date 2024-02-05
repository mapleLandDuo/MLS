//
//  DictionaryMonsterViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 1/28/24.
//

import UIKit

import Kingfisher
import SnapKit

class DictionaryMonsterViewController: BasicController {
    // MARK: - Properties

    let viewModel: DictionaryMonsterViewModel

    // MARK: - Components

    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = .white
        view.separatorStyle = .none
        return view
    }()

    init(viewModel: DictionaryMonsterViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension DictionaryMonsterViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

// MARK: - SetUp
private extension DictionaryMonsterViewController {
    
    func setUp() {
        setUpConstraints()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DictionaryNameImageCell.self, forCellReuseIdentifier: DictionaryNameImageCell.identifier)
        tableView.register(DictionaryMonsterDefaultCell.self, forCellReuseIdentifier: DictionaryMonsterDefaultCell.identifier)
        tableView.register(DictionaryMonsterDetailCell.self, forCellReuseIdentifier: DictionaryMonsterDetailCell.identifier)
        tableView.register(DictionaryMonsterHauntAreaCell.self, forCellReuseIdentifier: DictionaryMonsterHauntAreaCell.identifier)
        tableView.register(DictionaryGraySeparatorOneLineCell.self, forCellReuseIdentifier: DictionaryGraySeparatorOneLineCell.identifier)
    }

    func setUpConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { 
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension DictionaryMonsterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 3:
            return viewModel.fetchItem().hauntArea.count
        case 4:
            return viewModel.fetchItem().dropTable.count
        default:
            return 1
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryNameImageCell.identifier, for: indexPath) as? DictionaryNameImageCell else { return UITableViewCell() }
            cell.bind(item: viewModel.fetchItem())
            cell.selectionStyle = .none
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryMonsterDefaultCell.identifier, for: indexPath) as? DictionaryMonsterDefaultCell else { return UITableViewCell() }
            cell.bind(item: viewModel.fetchItem())
            cell.selectionStyle = .none
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryMonsterDetailCell.identifier, for: indexPath) as? DictionaryMonsterDetailCell else { return UITableViewCell() }
            cell.bind(item: viewModel.fetchItem())
            cell.selectionStyle = .none
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryGraySeparatorOneLineCell.identifier, for: indexPath) as? DictionaryGraySeparatorOneLineCell else { return UITableViewCell() }
            let item = DictionaryNameDescription(name: viewModel.fetchItem().hauntArea[indexPath.row], description: "")
            cell.bind(data: item)
            cell.selectionStyle = .none
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryGraySeparatorOneLineCell.identifier, for: indexPath) as? DictionaryGraySeparatorOneLineCell else { return UITableViewCell() }
            cell.bind(data: viewModel.fetchItem().dropTable[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 4:
            let itemName = viewModel.fetchItem().dropTable[indexPath.row].name
            if itemName == "메소" { return }
            IndicatorMaker.showLoading()
            FirebaseManager.firebaseManager.loadItem(itemName: itemName) { item in
                guard let item = item else { return }
                IndicatorMaker.hideLoading()
                let vc = DictionaryItemViewController(viewModel: DictionaryItemViewModel(item: item))
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
            return makeHeaderView(title: "출몰 지역")
        case 4:
            return makeHeaderView(title: "드랍 테이블")
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
