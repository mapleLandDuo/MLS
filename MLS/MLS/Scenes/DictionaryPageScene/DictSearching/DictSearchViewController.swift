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
    
    private let searchTrailingView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.semanticColor.bolder.interactive.secondary?.cgColor
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "caret-left"), for: .normal)
        return button
    }()
    
    private let topStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.spacing = Constants.spacings.sm
        return view
    }()
    
    private let searchStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.spacing = Constants.spacings.xs
        return view
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.tintColor = .semanticColor.bolder.interactive.primary
        textField.font = .customFont(fontSize: .body_md, fontType: .medium)
        return textField
    }()
    
    private let searchClearButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close-circle"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    private let searchingView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    private let recentSearchKeywordCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.spacings.md
        layout.sectionInset = .init(top: 0, left: Constants.spacings.xl, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private let recentSearchClearButton: UIButton = {
        let button = UIButton()
        button.setTitle("모두 지우기", for: .normal)
        button.setTitleColor(.semanticColor.text.info, for: .normal)
        button.titleLabel?.font = .customFont(fontSize: .body_sm, fontType: .medium)
        return button
    }()
    
    private let searchView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let searchMenuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.spacings.md
        layout.sectionInset = .init(top: 0, left: Constants.spacings.xl, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .red
        return view
    }()

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
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.searchTextField.becomeFirstResponder()
        }
        
    }
}

// MARK: - Bind
private extension DictSearchViewController {
    func bind() {
        let manager = UserDefaultsManager()
        viewModel.recentSearchKeywords.bind { [weak self] keywords in
            guard let keywords = keywords else { return }
            manager.setRecentSearchKeyWord(keyWords: keywords)
            self?.recentSearchKeywordCollectionView.reloadData()
        }
    }
}

// MARK: - SetUp
private extension DictSearchViewController {
    func setUp() {
        setUpConstraints()
        setUpAddAction()
        searchTextField.delegate = self
        recentSearchKeywordCollectionView.dataSource = self
        recentSearchKeywordCollectionView.delegate = self
        recentSearchKeywordCollectionView.register(RecentSearchKeywordCell.self, forCellWithReuseIdentifier: RecentSearchKeywordCell.identifier)
    }
    
    func setUpAddAction() {
        backButton.addAction(UIAction(handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }), for: .primaryActionTriggered)
        searchClearButton.addAction(UIAction(handler: { [weak self] _ in
            self?.searchTextField.text = ""
        }), for: .primaryActionTriggered)
        recentSearchClearButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.recentSearchKeywords.value = []
            self.searchView.isHidden = false
            self.searchingView.isHidden = true
        }), for: .primaryActionTriggered)
    }
    
    func setUpConstraints() {
        
        topStackView.addArrangedSubview(backButton)
        topStackView.addArrangedSubview(searchTrailingView)
        searchTrailingView.addSubview(searchTextField)
        searchStackView.addArrangedSubview(searchTextField)
        searchStackView.addArrangedSubview(searchClearButton)
        searchTrailingView.addSubview(searchStackView)
        view.addSubview(topStackView)
        view.addSubview(searchingView)
        view.addSubview(searchView)
        searchingView.addSubview(recentSearchKeywordCollectionView)
        searchingView.addSubview(recentSearchClearButton)
        searchView.addSubview(searchMenuCollectionView)
        
        backButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        searchTrailingView.snp.makeConstraints {
            $0.height.equalTo(Constants.spacings.xl_4)
            $0.top.equalToSuperview().inset(Constants.spacings.lg)
            $0.bottom.equalToSuperview().inset(Constants.spacings.xl)
        }
        
        topStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.spacings.lg)
            $0.leading.equalToSuperview().inset(Constants.spacings.lg)
            $0.trailing.equalToSuperview().inset(Constants.spacings.xl)
        }
        
        searchClearButton.snp.makeConstraints {
            $0.width.height.equalTo(Constants.spacings.xl)
        }
        
        searchStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.spacings.lg)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.sm)
        }
        
        searchingView.snp.makeConstraints {
            $0.top.equalTo(topStackView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        recentSearchKeywordCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.spacings.xl_3)
        }
        
        recentSearchClearButton.snp.makeConstraints {
            $0.top.equalTo(recentSearchKeywordCollectionView.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(Constants.spacings.xl)
        }
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(topStackView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        searchMenuCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.spacings.xl_3)
        }
        
    }
}

extension DictSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let keyword = textField.text else { return true }
        viewModel.recentSearchKeywords.value?.insert(keyword, at: 0)
        view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchTrailingView.layer.borderColor = UIColor.semanticColor.bolder.interactive.primary_pressed?.cgColor
        searchClearButton.isHidden = false
        guard let keywords = viewModel.recentSearchKeywords.value else { return }
        if keywords.isEmpty {
            searchView.isHidden = false
            searchingView.isHidden = true
        } else {
            searchView.isHidden = true
            searchingView.isHidden = false
        }
        print(#function)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchTrailingView.layer.borderColor = UIColor.semanticColor.bolder.interactive.secondary?.cgColor
        searchClearButton.isHidden = true
        searchView.isHidden = false
        searchingView.isHidden = true
        print(#function)
    }
}

extension DictSearchViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.recentSearchKeywords.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchKeywordCell.identifier, for: indexPath) as? RecentSearchKeywordCell else { return UICollectionViewCell() }
        cell.bind(text: viewModel.recentSearchKeywords.value?[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let keywords = viewModel.recentSearchKeywords.value else { return .zero}
        return .init(
            width: keywords[indexPath.row].size(withAttributes: [NSAttributedString.Key.font : UIFont.customFont(fontSize: .body_sm, fontType: .medium) ?? 0]).width + (Constants.spacings.md * 2) + Constants.spacings.xl + Constants.spacings.xs_2 + 5,
            height: Constants.spacings.xl_3
        )
    }
}

extension DictSearchViewController: RecentSearchKeywordCellDelegate {
    func didTapDeleteButton(index: Int) {
        viewModel.recentSearchKeywords.value?.remove(at: index)
        guard let keywords = viewModel.recentSearchKeywords.value else { return }
        if keywords.isEmpty {
            searchView.isHidden = false
            searchingView.isHidden = true
        } else {
            searchView.isHidden = true
            searchingView.isHidden = false
        }
    }
}
