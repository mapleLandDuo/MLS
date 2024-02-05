//
//  File.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/29.
//

import UIKit

import Kingfisher
import SnapKit

class DictionarySearchCell: UITableViewCell {
    // MARK: Components

    private let searchImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let searchTitleLabel = CustomLabel(text: "title", font: .boldSystemFont(ofSize: 20))

    private let searchLevelLabel = CustomLabel(text: "level", font: .systemFont(ofSize: 16))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: SetUp
private extension DictionarySearchCell {

    func setUp() {
        setupConstraints()
    }

    func setupConstraints() {
        addSubview(searchImageView)
        addSubview(searchTitleLabel)
        addSubview(searchLevelLabel)

        searchImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.defaults.vertical)
            $0.leading.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.size.equalTo(40)
        }

        searchTitleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.defaults.vertical)
            $0.leading.equalTo(searchImageView.snp.trailing).inset(-Constants.defaults.horizontal)
        }

        searchLevelLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.defaults.vertical)
            $0.leading.equalTo(searchTitleLabel.snp.trailing).inset(-Constants.defaults.horizontal)
            $0.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }
    }
}

// MARK: Bind
extension DictionarySearchCell {

    func bind(imageUrl: URL, title: String, level: String) {
        searchImageView.kf.setImage(with: imageUrl)
        searchTitleLabel.text = title
        searchLevelLabel.text = "LV. \(level)"
    }
}
