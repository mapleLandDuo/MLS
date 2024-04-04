//
//  DictSearchingViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 3/18/24.
//

import UIKit

import SnapKit

import RxSwift
import RxCocoa

class DictSearchingViewController: BasicController {
    
    // MARK: - Properties
    
    private let viewModel: DictSearchViewModel
    
    private var disposeBag = DisposeBag()
    
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
        super.viewDidLoad()
        bind()
        setUp()
    }
}

// MARK: - Bind
private extension DictSearchingViewController {
    func bind() {
        viewModel.recentSearchKeywords.map({$0.isEmpty}).subscribe { [weak self] isEmpty in
            guard let self = self else { return }
            self.viewModel.setRecentSearchKeywordToUserDefault()
            self.view.isHidden = isEmpty
        }.disposed(by: disposeBag)
        
        viewModel.recentSearchKeywords.bind(to: recentSearchKeywordCollectionView.rx
            .items(cellIdentifier: RecentSearchKeywordCell.identifier, cellType: RecentSearchKeywordCell.self)) { [weak self] index, item, cell in
                guard let self = self else { return }
                cell.bind(text: item, index: index)
                cell.delegate = self
        }.disposed(by: disposeBag)
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
            self.viewModel.didTapRecentSearchKeywordClearButton()
        }), for: .primaryActionTriggered)
    }
    
    func setUpCollectionView() {
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
        viewModel.removeRecentSearchKeyword(index: index)
    }
}

extension DictSearchingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedRecentSearchKeyword(index: indexPath.row)
        view.endEditing(true)
        viewModel.setDictDatasToSearchKeyword()
        viewModel.setIsSearching(isSearching: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let keywords = viewModel.fetchRecentSearchKeywords()
        return .init(
            width: keywords[indexPath.row].size(withAttributes: [NSAttributedString.Key.font : UIFont.customFont(fontSize: .body_sm, fontType: .medium) ?? 0]).width + (Constants.spacings.md * 2) + Constants.spacings.xl + Constants.spacings.xs_2 + 5,
            height: Constants.spacings.xl_3)
    }
}
