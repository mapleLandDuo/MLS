//
//  PopularViewController.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/04.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class PopularViewController: BasicController {
    // MARK: Properties
    private let viewModel: PopularViewModel

    // MARK: Components
    private let infoMenuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 0, left: Constants.spacings.xl, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Constants.spacings.xl_3
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        let backgroundView = UIView()
        let separator = UIView()
        separator.backgroundColor = .semanticColor.bolder.secondary
        backgroundView.addSubview(separator)
        separator.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(1)
            $0.height.equalTo(1)
        }
        view.backgroundView = backgroundView
        view.register(DictSearchMenuCell.self, forCellWithReuseIdentifier: DictSearchMenuCell.identifier)
        return view
    }()

    private let popularTableView: UITableView = {
        let view = UITableView()
        view.register(PopularTableViewCell.self, forCellReuseIdentifier: PopularTableViewCell.identifier)
        view.separatorStyle = .none
        return view
    }()

    init(viewModel: PopularViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Life Cycle
extension PopularViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
}

// MARK: SetUp
private extension PopularViewController {
    func setUp() {
        infoMenuCollectionView.delegate = self

        setUpConstraints()
        setUpNavigation(title: "인기 TOP")
    }

    func setUpConstraints() {
        view.addSubview(infoMenuCollectionView)
        view.addSubview(popularTableView)

        infoMenuCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }

        popularTableView.snp.makeConstraints {
            $0.top.equalTo(infoMenuCollectionView.snp.bottom).offset(Constants.spacings.xl)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: Bind
extension PopularViewController {
    func bind() {
        viewModel.selectedData
            .bind(to: popularTableView.rx.items(cellIdentifier: PopularTableViewCell.identifier, cellType: PopularTableViewCell.self)) { index, item, cell in
                let rank = (0 ... 2).contains(index) ? 0 : 1
                cell.selectionStyle = .none
                cell.bind(item: item, index: index, rank: rank)
            }
            .disposed(by: viewModel.disposeBag)

        popularTableView.rx.modelSelected(DictSectionData.self)
            .withUnretained(self)
            .subscribe(onNext: { owner, item in
                if item.type == .item {
                    let vm = DictItemViewModel(selectedName: item.title, type: .item)
                    let vc = DictItemViewController(viewModel: vm)
                    owner.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vm = DictMonsterViewModel(selectedName: item.title, type: .monster)
                    let vc = DictMonsterViewController(viewModel: vm)
                    owner.navigationController?.pushViewController(vc, animated: true)
                }
            })
            .disposed(by: viewModel.disposeBag)

        viewModel.tabMenus
            .bind(to: infoMenuCollectionView.rx.items(cellIdentifier: DictSearchMenuCell.identifier, cellType: DictSearchMenuCell.self)) { _, item, cell in
                cell.bind(text: item)
            }
            .disposed(by: viewModel.disposeBag)

        viewModel.selectedTab
            .withUnretained(self)
            .subscribe(onNext: { owner, selectedTab in
                let indexPath = IndexPath(item: selectedTab, section: 0)
                owner.infoMenuCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
            })
            .disposed(by: viewModel.disposeBag)

        infoMenuCollectionView.rx.itemSelected
            .distinctUntilChanged()
            .map { $0.row }
            .withUnretained(self)
            .subscribe(onNext: { owner, index in
                owner.viewModel.setMenuIndex(index: index)
            })
            .disposed(by: viewModel.disposeBag)
    }
}

// MARK: Methods
extension PopularViewController {
    /// 네비게이션바의 타이틀을 attributedString으로 설정
    /// - Parameter title: 사용하지 않지만 override를 위해 입력
    override func setUpNavigation(title: String) {
        let rightSpacer = UIBarButtonItem()
        let image = UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysTemplate)
        let searchImage = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTapBackButton))
        let searchButton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(didTapSearchButton))
        searchButton.width = 60

        let titleLabel = UILabel()
        let attributedString = NSMutableAttributedString(string: "인기 TOP", attributes: [NSAttributedString.Key.font: UIFont.customFont(fontSize: .heading_sm, fontType: .semiBold) ?? UIFont.systemFont(ofSize: 12)])
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], range: NSRange(location: 0, length: 2))
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.themeColor(color: .base, value: .value_black) ?? UIColor.black], range: NSRange(location: 3, length: 3))

        titleLabel.attributedText = attributedString
        navigationItem.titleView = titleLabel

        backButton.tintColor = .themeColor(color: .base, value: .value_black)
        searchButton.tintColor = .themeColor(color: .base, value: .value_black)
        navigationItem.leftBarButtonItems = [rightSpacer, backButton]
        navigationItem.rightBarButtonItem = searchButton
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.shadowImage = nil
    }

    @objc
    /// 검색버튼을 눌러서 SearchVC로 이동
    func didTapSearchButton() {
        let vm = DictSearchViewModel()
        let vc = DictSearchViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension PopularViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Double((Constants.screenWidth - Constants.spacings.xl_3 * 2) / 2)
        let height = 40.0
        return CGSize(width: width, height: height)
    }
}
