//
//  DictMonsterDropCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/02.
//

import UIKit

import SnapKit

class DictMonsterDropCell: UITableViewCell {
    // MARK: Properties
    private var items: [DictDropContent]?

    private var type: String?

    var tappedCell: ((String, DictType) -> Void)?
    
    // MARK: Components

    private let monsterDropTableView: UITableView = {
        let view = UITableView()
        view.register(DropTableViewCell.self, forCellReuseIdentifier: DropTableViewCell.identifier)
        view.separatorStyle = .none
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: SetUp
extension DictMonsterDropCell {
    func setUp() {
        monsterDropTableView.delegate = self
        monsterDropTableView.dataSource = self

        setUpConstraints()
    }

    func setUpConstraints() {
        addSubview(monsterDropTableView)

        monsterDropTableView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constants.spacings.xl)
        }
    }
}

// MARK: Bind
extension DictMonsterDropCell {
    func bind(items: [DictDropContent]?, type: String?) {
        if let items = items {
            self.items = items
            self.type = type
            monsterDropTableView.snp.remakeConstraints {
                $0.edges.equalToSuperview().inset(Constants.spacings.xl)
                $0.height.equalTo(80 * items.count)
            }
            monsterDropTableView.reloadData()
        }
    }
}

extension DictMonsterDropCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = items?.count else { return 0 }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DropTableViewCell.identifier) as? DropTableViewCell,
              let item = items?[indexPath.row],
              let type = type else { return UITableViewCell() }
        cell.bind(item: item, type: type)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = items?[indexPath.row] else { return }
        if item.title != "메소" {
            if item.description.contains("전달") {
                tappedCell?(item.title, .item)
            } else {
                tappedCell?(item.title, .monster)
            }
        }
    }
}
