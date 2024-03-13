//
//  DictItemInfoCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/01.
//

import UIKit

import SnapKit

protocol DictMainInfoCellDelegate: BasicController {
    func didTapExpandButton()
}

class DictMainInfoCell: UITableViewCell {
    // MARK: Properties
    private var descriptionText: String?

    weak var delegate: DictMainInfoCellDelegate?
    
    private var isExpanded = false
    
    private var descriptionViewHeight: CGFloat = 0.0
    
    // MARK: Components
    
    private let itemImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let nameLabel: CustomLabel = {
        let label = CustomLabel(text: "name", textColor: .semanticColor.text.interactive.inverse, font: .customFont(fontSize: .body_md, fontType: .bold))
        label.backgroundColor = .semanticColor.bg.interactive.secondary_pressed
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        return label
    }()
    
    lazy var descriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = .semanticColor.bg.primary
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let descriptionTextLabel: UILabel = {
        let view = UILabel()
        view.font = .customFont(fontSize: .body_sm, fontType: .regular)
        view.textColor = .semanticColor.text.primary
        view.backgroundColor = .clear
        view.numberOfLines = 2
        return view
    }()

    lazy var expandButton: UIButton = {
        let button = UIButton()
        button.tintColor = .semanticColor.text.primary
        button.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        button.setImage(UIImage(systemName: "arrowtriangle.up.fill"), for: .selected)
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.didTapExpandButton()
        }), for: .touchUpInside)
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
private extension DictMainInfoCell {
    func setUp() {
        setUpConstraints()
    }

    func setUpConstraints() {
        contentView.addSubview(itemImageView)
        contentView.addSubview(nameLabel)
        descriptionView.addSubview(descriptionTextLabel)
        descriptionView.addSubview(expandButton)
        contentView.addSubview(descriptionView)
        
        itemImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(80)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(itemImageView.snp.bottom).offset(44)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.height.equalTo(32)
        }
        
        expandButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Constants.spacings.lg)
            $0.width.equalTo(12)
            $0.height.equalTo(10)
            $0.centerY.equalToSuperview()
        }
        
        descriptionTextLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.spacings.sm)
            $0.leading.equalToSuperview().inset(Constants.spacings.lg)
            $0.trailing.equalTo(expandButton.snp.leading).inset(-Constants.spacings.sm)
            $0.height.equalTo(44)
        }
        
        descriptionView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(Constants.spacings.xs)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.bottom.equalToSuperview().inset(Constants.spacings.xl_2)
        }
        expandButton.contentHuggingPriority(for: .horizontal)
    }
}

// MARK: bind
extension DictMainInfoCell {
    func bind<T>(item: T) {
        var itemName: String
        var itemDescription: String?
        
        switch item.self {
        case is DictItem:
            guard let item = item as? DictItem,
                  let url = URL.getImageUrl(code: item.code, type: .items) else { return }
            itemName = item.name
            itemDescription = item.detailValues.filter { $0.name == "설명" }.first?.description
            descriptionText = itemDescription
            itemImageView.kf.setImage(with: url, placeholder: UIImage(named: "Deco-maple"))
        case is DictMonster:
            guard let item = item as? DictMonster,
                  let url = URL.getImageUrl(code: item.code, type: .monsters) else { return }
            let secondUrl = URL(string: "https://maplestory.io/api/kms/284/mob/\(item.code)/icon?resize=2")
            itemImageView.kf.setImage(with: url) { [weak self] result in
                switch result {
                case .failure:
                    print(#function)
                    self?.itemImageView.kf.setImage(with: secondUrl)
                default:
                    print(#function)
                }
            }
            itemName = item.name
            itemDescription = item.detailValues.filter { $0.name == "설명" }.first?.description
            descriptionText = itemDescription
        case is DictMap:
            guard let item = item as? DictMap else { return }
            itemName = item.name
            itemImageView.image = UIImage(named: "dictMapIcon")
        case is DictNPC:
            guard let item = item as? DictNPC,
                  let url = URL.getImageUrl(code: item.code, type: .npcs) else { return }
            itemName = item.name
            itemImageView.kf.setImage(with: url, placeholder: UIImage(named: "Deco-maple"))
        case is DictQuest:
            guard let item = item as? DictQuest else { return }
            itemName = item.name
            itemImageView.image = UIImage(named: "dictQuestIcon")
        default:
            return
        }
        
        checkDescriptionLines {
            self.expandButton.isHidden = self.descriptionViewHeight / 22 < 3 ? true : false
        }
        
        nameLabel.text = itemName
        
        if itemDescription == nil {
            descriptionTextLabel.snp.remakeConstraints {
                $0.top.bottom.equalToSuperview().inset(Constants.spacings.sm)
                $0.leading.trailing.equalToSuperview().inset(Constants.spacings.lg)
                $0.height.equalTo(44)
            }
        }
        descriptionTextLabel.text = itemDescription ?? "설명 없음"
        descriptionTextLabel.textAlignment = itemDescription == nil ? .center : .left
    }
}

extension DictMainInfoCell {
    func didTapExpandButton() {
        if !expandButton.isSelected {
            descriptionTextLabel.numberOfLines = 0
            descriptionTextLabel.snp.updateConstraints {
                $0.height.equalTo(descriptionViewHeight)
            }
        } else {
            descriptionTextLabel.numberOfLines = 2
            descriptionTextLabel.snp.updateConstraints {
                $0.height.equalTo(44)
            }
        }
        expandButton.isSelected.toggle()
        delegate?.didTapExpandButton()
    }
    
    func checkDescriptionLines(completion: @escaping () -> Void) {
        let width = Constants.screenWidth - (Constants.spacings.xl * 2) - (Constants.spacings.lg * 2)
        var descriptionVerticalCount: CGFloat = 2
        let descriptionWidth = NSString(string: descriptionText ?? "").size(
            withAttributes: [NSAttributedString.Key.font: UIFont.customFont(fontSize: .body_sm, fontType: .medium)!]
        ).width

        if !(width * 2 > descriptionWidth) {
            descriptionVerticalCount = CGFloat(Int(descriptionWidth / width) + 1)
        }
        descriptionViewHeight = (22 * descriptionVerticalCount) + (descriptionVerticalCount - 1)
        completion()
    }
}
