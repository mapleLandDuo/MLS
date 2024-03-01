//
//  DictItemInfoCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/01.
//

import UIKit

import SnapKit

class DictItemInfoCell: UITableViewCell {
    // MARK: Components

    private let ItemImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let nameLabel: CustomLabel = {
        let label = CustomLabel(text: "name", textColor: .semanticColor.text.interactive.inverse, font: .customFont(fontSize: .body_md, fontType: .bold))
        label.backgroundColor = .semanticColor.bg.interactive.secondary_pressed
        label.layer.cornerRadius = 8
        return label
    }()

    private let descriptionTextView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.textContainer.heightTracksTextView = false
        view.textColor = .semanticColor.text.primary
        view.backgroundColor = .semanticColor.bg.primary
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let expandButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        button.setImage(UIImage(systemName: "arrowtriangle.up.fill"), for: .selected)
        return button
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
private extension DictItemInfoCell {

    func setUp() {
        setUpConstraints()
    }

    func setUpConstraints() {
      
    }
}

// MARK: bind
extension DictItemInfoCell {

    func bind(item: DictionaryItem) {
      
    }
}
