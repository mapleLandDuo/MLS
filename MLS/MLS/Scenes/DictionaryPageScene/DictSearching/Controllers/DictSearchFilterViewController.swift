//
//  DictSearchFilterView.swift
//  MLS
//
//  Created by SeoJunYoung on 2/27/24.
//

import UIKit

import SnapKit

class DictSearchFilterViewController: BasicController {
    // MARK: - Properties
    
    private let type: DictType
    
    // MARK: - Components
    
    private let filterTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.separatorStyle = .none
        view.isScrollEnabled = false
        view.alwaysBounceVertical = true
        return view
    }()
    
    private let buttonStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = Constants.spacings.sm
        view.distribution = .fillEqually
        return view
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("초기화", for: .normal)
        button.setImage(UIImage(named: "refreshIcon_tertiary")?.resized(to: .init(width: Constants.spacings.xl, height: Constants.spacings.xl)), for: .normal)
        
        button.setTitleColor(.semanticColor.text.secondary, for: .normal)
        button.titleLabel?.font = .customFont(fontSize: .body_md, fontType: .semiBold)
        
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.semanticColor.bolder.secondary?.cgColor
        return button
    }()
    
    private let applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("아이템 찾아보기", for: .normal)
        button.titleLabel?.font = .customFont(fontSize: .body_md, fontType: .semiBold)
        button.setTitleColor(.themeColor(color: .base, value: .value_white), for: .normal)
        button.backgroundColor = .semanticColor.bg.interactive.primary
        button.layer.cornerRadius = 12
        return button
    }()
    
    init(type: DictType) {
        self.type = type
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - LifeCycle
extension DictSearchFilterViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

// MARK: - SetUp
private extension DictSearchFilterViewController {
    func setUp() {
        setUpConstraints()
        filterTableView.delegate = self
        filterTableView.dataSource = self
        filterTableView.register(DictSearchJobFilterCell.self, forCellReuseIdentifier: DictSearchJobFilterCell.identifier)
        filterTableView.register(DictSearchLevelRangeCell.self, forCellReuseIdentifier: DictSearchLevelRangeCell.identifier)
    }
    
    func setUpConstraints() {
        view.addSubview(filterTableView)
        buttonStackView.addArrangedSubview(resetButton)
        buttonStackView.addArrangedSubview(applyButton)
        view.addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.spacings.xl)
        }
        filterTableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(22)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(buttonStackView.snp.top)
        }
    }
}

extension DictSearchFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return type.filterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filterType = type.filterArray[indexPath.row]
        switch filterType {
        case .job:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DictSearchJobFilterCell.identifier) as? DictSearchJobFilterCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            return cell
        case .levelRange:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DictSearchLevelRangeCell.identifier) as? DictSearchLevelRangeCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            return cell
        }

    }
    
    
}
