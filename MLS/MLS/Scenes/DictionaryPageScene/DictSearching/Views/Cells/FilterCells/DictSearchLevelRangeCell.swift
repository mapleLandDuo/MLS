//
//  DictSearchLevelRangeCell.swift
//  MLS
//
//  Created by SeoJunYoung on 2/28/24.
//

import UIKit

import SnapKit

protocol DictSearchLevelRangeCellDelegate: BasicController {
    func availableRange(firstNum: Int, secondNum: Int)
}

class DictSearchLevelRangeCell: UITableViewCell {
    
    // MARK: - Properties
    
    weak var delegate: DictSearchLevelRangeCellDelegate?

    // MARK: - Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_md, fontType: .bold)
        label.textColor = .semanticColor.text.primary
        label.addCharacterSpacing()
        label.text = "레벨"
        return label
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .regular)
        label.text = " (1~150까지 입력해주세요)"
        label.textColor = .semanticColor.text.info_bold
        return label
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        return view
    }()
    
    private let leftTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 12
        textField.layer.borderColor = UIColor.semanticColor.bolder.interactive.secondary?.cgColor
        textField.layer.borderWidth = 1
        textField.placeholder = "1"
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let centerLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_md, fontType: .medium)
        label.textColor = .semanticColor.text.secondary
        label.text = "~"
        label.textAlignment = .center
        return label
    }()
    
    private let rightTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 12
        textField.layer.borderColor = UIColor.semanticColor.bolder.interactive.secondary?.cgColor
        textField.layer.borderWidth = 1
        textField.placeholder = "150"
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        return textField
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

// MARK: - SetUp
private extension DictSearchLevelRangeCell {
    
    func setUp() {
        setUpConstraints()
        leftTextField.delegate = self
        rightTextField.delegate = self
    }
    
    func setUpConstraints() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subLabel)
        stackView.addArrangedSubview(leftTextField)
        stackView.addArrangedSubview(centerLabel)
        stackView.addArrangedSubview(rightTextField)
        contentView.addSubview(stackView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(Constants.spacings.xl)
            $0.height.equalTo(Constants.spacings.xl)
        }
        
        subLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing)
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        leftTextField.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(Constants.spacings.xl_3)
        }
        
        centerLabel.snp.makeConstraints {
            $0.width.equalTo(27)
            $0.height.equalTo(Constants.spacings.xl_3)
        }
        
        rightTextField.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(Constants.spacings.xl_3)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.spacings.sm)
            $0.leading.equalToSuperview().inset(Constants.spacings.xl)
            $0.height.equalTo(Constants.spacings.xl_3)
            $0.bottom.equalToSuperview().inset(Constants.spacings.xl_2)
        }
    }
}

extension DictSearchLevelRangeCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case leftTextField:
            rightTextField.layer.borderColor = UIColor.semanticColor.bolder.interactive.secondary?.cgColor
            leftTextField.layer.borderColor = UIColor.semanticColor.bolder.interactive.primary?.cgColor
        case rightTextField:
            leftTextField.layer.borderColor = UIColor.semanticColor.bolder.interactive.secondary?.cgColor
            rightTextField.layer.borderColor = UIColor.semanticColor.bolder.interactive.primary?.cgColor
        default:
            print("등록되지 않은 텍스트 필드")
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.layer.borderColor = UIColor.semanticColor.bolder.interactive.secondary?.cgColor
        guard let firstString = leftTextField.text else { return true }
        guard let firstNum = Int(firstString) else { return true }
        guard let secondString = rightTextField.text else { return true }
        guard let secondNum = Int(secondString) else { return true }
        
        if (firstNum...150).contains(secondNum) {
            delegate?.availableRange(firstNum: firstNum, secondNum: secondNum)
        } else {
            rightTextField.text = nil
        }
        return true
    }
}

// MARK: - Bind
extension DictSearchLevelRangeCell {
    func bind(firstNum: String, secondNum: String) {
        leftTextField.text = firstNum
        rightTextField.text = secondNum
    }
}
