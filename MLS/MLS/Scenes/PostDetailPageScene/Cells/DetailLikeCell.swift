//
//  File.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/01.
//

import UIKit

import SnapKit

protocol DetailLikeCellDelegate: AnyObject {
    func tapUpCountButton(cell: DetailLikeCell)
}

class DetailLikeCell: UITableViewCell {
    // MARK: - Properties

    weak var delegate: DetailLikeCellDelegate?

    // MARK: - Components

    lazy var upCountButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = false
        button.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = Constants.defaults.radius
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.layer.borderWidth = 1
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 2
        button.addAction(UIAction(handler: { [weak self] _ in
            if let self = self {
                self.delegate?.tapUpCountButton(cell: self)
            }
        }), for: .touchUpInside)
        return button
    }()

    private let upCountView = UIView()

    private let upCountIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "orangeMushroom")?.resized(to: CGSize(width: 30, height: 30))
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let upCountLabel: CustomLabel = {
        let label = CustomLabel(text: "0", textColor: .gray, font: .systemFont(ofSize: 12))
        label.textAlignment = .center
        return label
    }()

    // MARK: - LifeCycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DetailLikeCell {
    // MARK: - SetUp

    func setUp() {
        addSubview(upCountButton)
        addSubview(upCountView)
        upCountView.addSubview(upCountIcon)
        upCountView.addSubview(upCountLabel)

        upCountButton.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(60)
        }

        upCountView.snp.makeConstraints {
            $0.top.equalTo(upCountButton.snp.bottom)
            $0.bottom.centerX.equalToSuperview()
        }

        upCountIcon.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.size.equalTo(30)
        }

        upCountLabel.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalTo(upCountIcon.snp.trailing)
            $0.size.equalTo(upCountIcon)
        }
    }
}

extension DetailLikeCell {
    // MARK: - Method

    func bind(post: Post, isUp: Bool) {
        upCountLabel.text = String(post.likes.count)
        upCountButton.setImage(isUp ? UIImage(systemName: "hand.thumbsup.fill") : UIImage(systemName: "hand.thumbsup"), for: .normal)
    }
}
