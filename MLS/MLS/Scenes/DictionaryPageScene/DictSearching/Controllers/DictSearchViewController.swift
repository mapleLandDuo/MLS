//
//  DictSearchViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 2/22/24.
//

import UIKit

import SnapKit

import RxCocoa
import RxSwift

class DictSearchViewController: BasicController {
    // MARK: - Properties
    
    private let viewModel: DictSearchViewModel
    
    private var disposeBag = DisposeBag()
    
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
        viewModel.isSearching.map({ [weak self] in
            guard let self = self else { return !$0 }
            return self.viewModel.fetchRecentSearchKeywords().isEmpty ? true : !$0}
        ).bind(to: searchingVC.view.rx.isHidden).disposed(by: disposeBag)
        
        viewModel.isSearching.subscribe { [weak self] isSearching in
            guard let self = self else { return }
            self.headerView.activateTextField(isActive: isSearching)
        }.disposed(by: disposeBag)
        
        headerView.searchTextField.rx.text.orEmpty.bind(to: viewModel.searchKeyword).disposed(by: disposeBag)
        
        viewModel.searchKeyword.bind(to: headerView.searchTextField.rx.text).disposed(by: disposeBag)
        
        viewModel.isLoading.subscribe { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                IndicatorManager.showIndicator(vc: self)
            } else {
                IndicatorManager.hideIndicator(vc: self)
            }
        }.disposed(by: disposeBag)
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
        view.endEditing(true)
        viewModel.appendRecentSearchKeyword()
        viewModel.setIsSearching(isSearching: false)
        viewModel.setDictDatasToSearchKeyword()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewModel.setIsSearching(isSearching: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel.setIsSearching(isSearching: false)
    }
}


