//
//  DictionaryItemViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 1/28/24.
//

import Foundation
import UIKit

class DictionaryItemViewController: BasicController {
    // MARK: - Property
    let viewModel: DictionaryItemViewModel
    // MARK: - Componets
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension DictionaryItemViewController {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}
private extension DictionaryItemViewController {
    // MARK: - SetUp
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
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension DictionaryItemViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            let item = viewModel.getItem()
            let tempArray = [
                "description": item.description,
                "str": item.str,
                "dex": item.dex,
                "luk": item.luk,
                "int": item.int
            ]
            let datas = tempArray.filter({$0.value != nil})
            return datas.count + 1
        case 2:
            return viewModel.getItem().detailDescription.count
        case 3:
            return viewModel.getItem().dropTable.count
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryNameImageCell.identifier, for: indexPath) as? DictionaryNameImageCell else { return UITableViewCell()}
            cell.bind(item: viewModel.getItem())
            cell.selectionStyle = .none
            return cell
        case 1:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryItemDefaultCell.identifier, for: indexPath) as? DictionaryItemDefaultCell else { return UITableViewCell()}
                cell.bind(item: viewModel.getItem())
                cell.selectionStyle = .none
                return cell
            } else {

                let datas = viewModel.getDefaultInfoArray()
                if datas[indexPath.row - 1].name == "설명" {
                    print("description cell")
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
            let datas = viewModel.getDetailInfoArray()
            cell.bind(data: datas[indexPath.row])
            cell.selectionStyle = .none
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryGraySeparatorOneLineCell.identifier, for: indexPath) as? DictionaryGraySeparatorOneLineCell else { return UITableViewCell() }
            cell.bind(data: viewModel.getItem().dropTable[indexPath.row])
            cell.selectionStyle = .none
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryGraySeparatorOneLineCell.identifier, for: indexPath) as? DictionaryGraySeparatorOneLineCell else { return UITableViewCell()}
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 3:
            let monsterName = viewModel.getItem().dropTable[indexPath.row].name
            IndicatorMaker.showLoading()
            FirebaseManager.firebaseManager.loadMonster(monsterName: monsterName) { item in
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
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        view.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        
        return view
    }
}
