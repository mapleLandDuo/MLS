//
//  DictionaryMonsterViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 1/28/24.
//

import UIKit
import SnapKit
import Kingfisher

class DictionaryMonsterViewController: BasicController {
    // MARK: - Property
    let viewModel: DictionaryMonsterViewModel

    // MARK: - Componetns
    
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DictionaryMonsterViewController {
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

}

private extension DictionaryMonsterViewController {
    func setUp() {
        setUpConstraints()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DictionaryNameImageCell.self, forCellReuseIdentifier: DictionaryNameImageCell.identifier)
        tableView.register(DictionaryMonsterDefaultCell.self, forCellReuseIdentifier: DictionaryMonsterDefaultCell.identifier)
        tableView.register(DictionaryMonsterDetailCell.self, forCellReuseIdentifier: DictionaryMonsterDetailCell.identifier)
        tableView.register(DictionaryMonsterHauntAreaCell.self, forCellReuseIdentifier: DictionaryMonsterHauntAreaCell.identifier)
        tableView.register(DictionaryMonsterDropTableCell.self, forCellReuseIdentifier: DictionaryMonsterDropTableCell.identifier)
    }
    func setUpConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension DictionaryMonsterViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 4:
            return viewModel.getItem().dropTable.count
        default:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryNameImageCell.identifier, for: indexPath) as? DictionaryNameImageCell else { return UITableViewCell()}
            cell.bind(item: viewModel.getItem())
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryMonsterDefaultCell.identifier, for: indexPath) as? DictionaryMonsterDefaultCell else { return UITableViewCell()}
            cell.bind(item: viewModel.getItem())
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryMonsterDetailCell.identifier, for: indexPath) as? DictionaryMonsterDetailCell else { return UITableViewCell()}
            cell.bind(item: viewModel.getItem())
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryMonsterHauntAreaCell.identifier, for: indexPath) as? DictionaryMonsterHauntAreaCell else { return UITableViewCell()}
            cell.bind(item: viewModel.getItem())
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DictionaryMonsterDropTableCell.identifier, for: indexPath) as? DictionaryMonsterDropTableCell else { return UITableViewCell()}
            cell.bind(item: viewModel.getItem().dropTable[indexPath.row])
            return cell
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
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
