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
    private let leadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .semanticColor.bg.primary
        view.layer.cornerRadius = 8
        return view
    }()

    private let defaultTableView: UITableView = {
        let view = UITableView()
        view.register(DictDescriptionCell.self, forCellReuseIdentifier: DictDescriptionCell.identifier)
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
private extension DictDetailContentsCell {
    func setUp() {
        setUpConstraints()

        defaultTableView.delegate = self
        defaultTableView.dataSource = self
    }

    func setUpConstraints() {
        contentView.addSubview(leadingView)
        leadingView.addSubview(defaultTableView)

        leadingView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.spacings.lg)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
        }

        defaultTableView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constants.spacings.xl)
        }
    }
}

// MARK: bind
extension DictDetailContentsCell {
    func bind(items: [DetailContent]?) {
        if let items = items {
            self.items = items
            contentView.snp.remakeConstraints {
                $0.edges.equalToSuperview()
                $0.height.equalTo(24 * items.count + Int(Constants.spacings.xl) * 2)
            }
            
            leadingView.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(Constants.spacings.lg)
                $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
                $0.height.equalTo(24 * items.count + Int(Constants.spacings.xl) * 2)
            }

            defaultTableView.reloadData()
        } else {
            defaultTableView.isHidden = true
        }
    }
}

extension DictDetailContentsCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = items?.count else { return 0 }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DictDescriptionCell.identifier) as? DictDescriptionCell,
              let item = items?[indexPath.row] else { return UITableViewCell() }
        cell.bind(item: item)
        cell.selectionStyle = .none
        return cell
    }
}
