//
//  DictSearchingViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 3/18/24.
//

import UIKit

import SnapKit

class DictSearchingViewController: BasicController {
    
    // MARK: - Properties
    
    private let viewModel: DictSearchViewModel
    
    // MARK: - Components
    
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
    
    init(viewModel: DictSearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - LifeCycle
extension DictSearchingViewController {
    override func viewDidLoad() {
        setUp()
        bind()
    }
}

// MARK: - Bind
private extension DictSearchingViewController {
    func bind() {
        let manager = UserDefaultsManager()
        viewModel.recentSearchKeywords.bind { [weak self] keywords in
            guard let keywords = keywords else { return }
            manager.setRecentSearchKeyWord(keyWords: keywords)
            self?.recentSearchKeywordCollectionView.reloadData()
            if keywords.isEmpty {
                self?.view.isHidden = true
            } else {
                self?.view.isHidden = false
            }
        }
    }
}

private extension DictSearchingViewController {
    
    func setUp() {
        setUpConstraints()
        setUpCollectionView()
        view.isHidden = true
        view.backgroundColor = .themeColor(color: .base, value: .value_white)
        recentSearchClearButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.recentSearchKeywords.value = []
        }), for: .primaryActionTriggered)
    }
    
    func setUpCollectionView() {
        recentSearchKeywordCollectionView.dataSource = self
        recentSearchKeywordCollectionView.delegate = self
        recentSearchKeywordCollectionView.register(RecentSearchKeywordCell.self, forCellWithReuseIdentifier: RecentSearchKeywordCell.identifier)
    }
    
    func setUpConstraints() {
        
        view.addSubview(recentSearchKeywordCollectionView)
        view.addSubview(recentSearchClearButton)
        
        recentSearchKeywordCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.spacings.xl_3)
        }
        
        recentSearchClearButton.snp.makeConstraints {
            $0.top.equalTo(recentSearchKeywordCollectionView.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(Constants.spacings.xl)
        }
    }
}

extension DictSearchingViewController: RecentSearchKeywordCellDelegate {
    func didTapDeleteButton(index: Int) {
        viewModel.recentSearchKeywords.value?.remove(at: index)
    }
}

extension DictSearchingViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.recentSearchKeywords.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchKeywordCell.identifier, for: indexPath) as? RecentSearchKeywordCell else { return UICollectionViewCell() }
        cell.bind(text: viewModel.recentSearchKeywords.value?[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let keywords = viewModel.recentSearchKeywords.value else { return }
        let keyword = keywords[indexPath.row]
        var cleanKeywords: [String] = [keyword]
        for keyword in keywords {
            if !cleanKeywords.contains(keyword) { cleanKeywords.append(keyword) }
        }
        viewModel.recentSearchKeywords.value = cleanKeywords
        viewModel.fetchSearchData(keyword: keyword)
        viewModel.searchKeyword.value = keyword
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let keywords = viewModel.recentSearchKeywords.value else { return .zero }
        return .init(
            width: keywords[indexPath.row].size(withAttributes: [NSAttributedString.Key.font : UIFont.customFont(fontSize: .body_sm, fontType: .medium) ?? 0]).width + (Constants.spacings.md * 2) + Constants.spacings.xl + Constants.spacings.xs_2 + 5,
            height: Constants.spacings.xl_3)
        
    }
}
