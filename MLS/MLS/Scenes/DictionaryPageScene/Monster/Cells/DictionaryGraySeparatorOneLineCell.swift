//
//  DictionaryMonsterDropTableCell.swift
//  MLS
//
//  Created by SeoJunYoung on 1/29/24.
//

import Foundation
import UIKit

class DictionaryGraySeparatorOneLineCell: UITableViewCell {
    // MARK: - Componetns
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title3.font
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title3.font
        return label
    }()
    
    private let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DictionaryGraySeparatorOneLineCell {
    func setUp() {
        setUpConstraints()
    }
    func setUpConstraints() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(descriptionLabel)
        contentView.addSubview(bottomSeparatorView)
        bottomSeparatorView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
}

extension DictionaryGraySeparatorOneLineCell {
    // MARK: - bind
    func bind(item: DictionaryMonsterDropTable) {
        nameLabel.text = item.name
        descriptionLabel.text = item.discription
    }
    func bind(data: DictionaryNameDescription) {
        nameLabel.text = data.name
        descriptionLabel.text = data.description
    }
    func bind(item: DictionaryItemDropTable) {
        nameLabel.text = item.name
        descriptionLabel.text = item.discription
    }
}
