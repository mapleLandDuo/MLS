//
//  DictSearchViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 2/22/24.
//

import UIKit

import SnapKit

class DictSearchViewController: BasicController {
    // MARK: - Properties
    
    private let viewModel: DictSearchViewModel
    
    // MARK: - Components
    
    let headerView = DictSearchHeaderView()
    
    lazy var searchingVC = DictSearchingViewController(viewModel: self.viewModel)
    
    lazy var searchResultVC = DictSearchResultViewController(viewModel: self.viewModel)
    
    init(viewModel: DictSearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - LifeCycle
extension DictSearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
}

// MARK: - Bind
private extension DictSearchViewController {
    func bind() {
        viewModel.searchKeyword.bind { [weak self] keyword in
            self?.headerView.searchTextField.text = keyword
            self?.view.endEditing(true)
        }
    }
}

// MARK: - SetUp
private extension DictSearchViewController {
    
    func setUp() {
        setUpConstraints()
        setUpAddAction()
        setUpDelegate()
    }
    
    func setUpDelegate() {
        headerView.searchTextField.delegate = self
    }
    
    func setUpAddAction() {
        headerView.backButton.addAction(UIAction(handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }), for: .primaryActionTriggered)
        headerView.searchClearButton.addAction(UIAction(handler: { [weak self] _ in
            self?.headerView.searchTextField.text = ""
        }), for: .primaryActionTriggered)
    }
    
    func setUpConstraints() {
        view.addSubview(headerView)

        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.addChild(searchResultVC)
        view.addSubview(searchResultVC.view)
        
        searchResultVC.view.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        self.addChild(searchingVC)
        view.addSubview(searchingVC.view)
        
        searchingVC.view.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension DictSearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let keyword = textField.text else { return true }
        if keyword.replacingOccurrences(of: " ", with: "").count == 0 {
            viewModel.setOriginDataToAllData()
        } else {
            guard let keywords = viewModel.recentSearchKeywords.value else { return true }
            var cleanKeywords: [String] = [keyword]
            for keyword in keywords {
                if !cleanKeywords.contains(keyword) { cleanKeywords.append(keyword) }
            }
            viewModel.recentSearchKeywords.value = cleanKeywords
            viewModel.setOriginData(keyword: keyword)
        }
        view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        headerView.searchTrailingView.layer.borderColor = UIColor.semanticColor.bolder.interactive.primary_pressed?.cgColor
        headerView.searchClearButton.isHidden = false
        guard let keywords = viewModel.recentSearchKeywords.value else { return }
        if keywords.isEmpty {
            searchingVC.view.isHidden = true
        } else {
            searchingVC.view.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        headerView.searchTrailingView.layer.borderColor = UIColor.semanticColor.bolder.interactive.secondary?.cgColor
        headerView.searchClearButton.isHidden = true
        searchingVC.view.isHidden = true
    }
}


