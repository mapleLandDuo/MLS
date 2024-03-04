//
//  PopularViewController.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/04.
//

import UIKit

import SnapKit

class PopularViewController: BasicController {
    // MARK: Properties

    let viewModel: PopularViewModel

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
        popularTableView.delegate = self
        popularTableView.dataSource = self

        infoMenuCollectionView.delegate = self
        infoMenuCollectionView.dataSource = self

        setUpConstraints()
        setUpNavigation()
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
        viewModel.datas.bind { [weak self] _ in
            self?.popularTableView.reloadData()
        }
        
        viewModel.selectedTab.bind { [weak self] _ in
            self?.popularTableView.reloadData()
        }
    }
}

// MARK: Methods
extension PopularViewController {
    func setUpNavigation() {
        let rightSpacer = UIBarButtonItem()
        let image = UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysTemplate)
        let searchImage = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTapBackButton))
        let searchButton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(didTapSearchButton))
        searchButton.width = 60

        let titleLabel = UILabel()
        let attributedString = NSMutableAttributedString(string: "인기 TOP", attributes: [NSAttributedString.Key.font: UIFont.customFont(fontSize: .heading_sm, fontType: .semiBold)])
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], range: NSRange(location: 0, length: 2))
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.themeColor(color: .base, value: .value_black)], range: NSRange(location: 3, length: 3))

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
    func didTapSearchButton() {
        let vm = DictSearchViewModel()
        let vc = DictSearchViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension PopularViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.selectedTab.value {
        case 0:
            guard let count = viewModel.datas.value?[0].datas.count else { return 0 }
            return count
        case 1:
            guard let count = viewModel.datas.value?[1].datas.count else { return 0 }
            return count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PopularTableViewCell.identifier) as? PopularTableViewCell else { return UITableViewCell() }
        switch viewModel.selectedTab.value {
        case 0:
            guard let item = viewModel.datas.value?[0].datas[indexPath.row] else { return UITableViewCell() }
            if (0 ... 2).contains(indexPath.row) {
                cell.bind(item: item, index: indexPath.row, rank: 0)
            } else {
                cell.bind(item: item, index: indexPath.row, rank: 1)
            }
        case 1:
            guard let item = viewModel.datas.value?[1].datas[indexPath.row] else { return UITableViewCell() }
            if (0 ... 2).contains(indexPath.row) {
                cell.bind(item: item, index: indexPath.row, rank: 0)
            } else {
                cell.bind(item: item, index: indexPath.row, rank: 1)
            }
        default:
            break
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.selectedTab.value {
        case 0:
            guard let item = viewModel.datas.value?[0].datas[indexPath.row] else { return }
            let vm = DictItemViewModel(selectedName: item.title)
            let vc = DictItemViewController(viewModel: vm)
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            guard let item = viewModel.datas.value?[1].datas[indexPath.row] else { return }
            let vm = DictMonsterViewModel(selectedName: item.title)
            let vc = DictMonsterViewController(viewModel: vm)
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

extension PopularViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tabMenus.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DictSearchMenuCell.identifier, for: indexPath) as? DictSearchMenuCell else { return UICollectionViewCell() }
        cell.bind(text: viewModel.tabMenus[indexPath.row])
        if indexPath.item == viewModel.fetchMenuIndex() {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.setMenuIndex(index: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Double((Constants.screenWidth - Constants.spacings.xl_3 * 2) / 2)
        let height = 40.0
        return CGSize(width: width, height: height)
    }
}
