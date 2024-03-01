//
//  DictItemDefaultCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/01.
//

import UIKit

import SnapKit

class DictDetailContentsCell: UITableViewCell {
    // MARK: Properties
    private var items: [DetailContent]?
    
    // MARK: Components
    private let defaultTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .semanticColor.bg.primary
        view.layer.cornerRadius = 8
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
private extension DictDetailContentsCell {
    func setUp() {
        defaultTableView.delegate = self
        
        setUpConstraints()
    }

    func setUpConstraints() {
        addSubview(defaultTableView)
    }
}

// MARK: bind
extension DictDetailContentsCell {
    func bind(items: [DetailContent]) {
        self.items = items
    }
}

extension DictDetailContentsCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = items?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        guard let item = items?[indexPath.row] else { return UITableViewCell()}
        var content = cell.defaultContentConfiguration()
        content.text = item.title
        content.secondaryText = item.description
        cell.contentConfiguration = content
        return cell
    }
}
