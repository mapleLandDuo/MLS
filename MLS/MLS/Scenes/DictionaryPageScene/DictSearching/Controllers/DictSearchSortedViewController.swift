//
//  DictSearchSortedViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 2/27/24.
//

import UIKit

import SnapKit

protocol DictSearchSortedViewControllerDelegate: BasicController {
    func viewWillDisappear(type: DictType, sortedEnum: DictSearchSortedEnum)
}

class DictSearchSortedViewController: BasicController {
    // MARK: - Properties
    
    private let type: DictType
    
    var selectSortedEnum: DictSearchSortedEnum
    
    weak var delegate: DictSearchSortedViewControllerDelegate?
    
    // MARK: - Components
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .semanticColor.bolder.primary
        return view
    }()
    
    private let tableview: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.separatorStyle = .none
        return view
    }()

    
    init(type: DictType, selectSortedEnum: DictSearchSortedEnum) {
        self.type = type
        self.selectSortedEnum = selectSortedEnum
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// MARK: - LifeCycle
extension DictSearchSortedViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.viewWillDisappear(type: type, sortedEnum: selectSortedEnum)
    }
}

// MARK: - SetUp
private extension DictSearchSortedViewController {
    
    func setUp() {
        setUpConstraints()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(DictSearchSortedCell.self, forCellReuseIdentifier: DictSearchSortedCell.identifier)
    }
    
    func setUpConstraints() {
        view.addSubview(separatorView)
        view.addSubview(tableview)
        
        separatorView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(22)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        tableview.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension DictSearchSortedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return type.sortedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DictSearchSortedCell.identifier) as? DictSearchSortedCell else { return UITableViewCell() }
        let datas = type.sortedArray
        cell.bind(title: datas[indexPath.row].rawValue)
        cell.selectionStyle = .none
        if selectSortedEnum == datas[indexPath.row] {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let datas = type.sortedArray
        selectSortedEnum = datas[indexPath.row]
        self.dismiss(animated: true)
    }
}
