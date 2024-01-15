//
//  SearchTableViewCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/15.
//

import UIKit

import SnapKit

class SearchTableViewCell: UITableViewCell {
    // MARK: Properties

    private let postView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemOrange.cgColor
        view.layer.cornerRadius = Constants.defaults.radius
        return view
    }()

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()

    // MARK: LifeCycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SearchTableViewCell {
    func setUp() {
        addSubview(postView)
        postView.addSubview(searchBar)

        postView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }

        searchBar.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
}
