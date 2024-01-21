//
//  MainPageViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 1/14/24.
//

import Foundation
import UIKit
import SnapKit

class MainPageViewController: BasicController {
    // MARK: - Property
    private let viewModel: MainPageViewModel

    // MARK: - Components

    private let menuButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        let image = UIImage(systemName: "list.bullet", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .systemGray4
        return button
    }()
    
    private let featureCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.defaults.vertical
        layout.minimumInteritemSpacing = Constants.defaults.horizontal
        layout.sectionInset = .init(top: Constants.defaults.vertical, left: 0, bottom: 0, right: 0)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    private let sideMenuView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let sideMenuEmptyView: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    private let sideMenuTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .systemGray4
        view.separatorStyle = .none
        return view
    }()
    
    init(viewModel: MainPageViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension MainPageViewController {
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .systemOrange
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
}

private extension MainPageViewController {
    // MARK: - SetUp

    func setUp() {
        setUpConstraints()
        featureCollectionView.delegate = self
        featureCollectionView.dataSource = self
        sideMenuTableView.dataSource = self
        menuButton.addTarget(self, action: #selector(didTapMenuButton), for: .primaryActionTriggered)
        sideMenuEmptyView.addTarget(self, action: #selector(didTapMenuEmptySpace), for: .primaryActionTriggered)
    }
    
    func setUpConstraints() {
        view.addSubview(menuButton)
        menuButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(Constants.defaults.horizontal)
            make.height.width.equalTo(Constants.defaults.blockHeight)
        }
        view.addSubview(featureCollectionView)
        featureCollectionView.register(MainPageFeatureDefaultsCell.self, forCellWithReuseIdentifier: MainPageFeatureDefaultsCell.identifier)
        featureCollectionView.register(MainPageFeatureListCell.self, forCellWithReuseIdentifier: MainPageFeatureListCell.identifier)
        featureCollectionView.snp.makeConstraints { make in
            make.top.equalTo(menuButton.snp.bottom).offset(Constants.defaults.vertical)
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        view.addSubview(sideMenuView)
        sideMenuView.snp.makeConstraints { make in
            make.height.equalTo(Constants.screenHeight)
            make.width.equalTo(Constants.screenWidth)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.right.equalTo(view.snp.left)
        }
        sideMenuView.addSubview(sideMenuEmptyView)
        sideMenuEmptyView.snp.makeConstraints { make in
            make.height.equalTo(Constants.screenHeight)
            make.width.equalTo(Constants.screenWidth * 0.3)
            make.right.top.equalToSuperview()
        }
        sideMenuView.addSubview(sideMenuTableView)
        sideMenuTableView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalTo(Constants.screenWidth * 0.7)
            make.height.equalTo(Constants.screenHeight)
        }
    }
}

private extension MainPageViewController {
    @objc
    func didTapMenuButton() {
        switchMenuView(isOpen: true)
    }
    @objc
    func didTapMenuEmptySpace() {
        switchMenuView(isOpen: false)
    }
    
    func switchMenuView(isOpen: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            let value: CGFloat = isOpen ? Constants.screenWidth : -Constants.screenWidth
            self.sideMenuView.transform = CGAffineTransform(
                translationX: self.sideMenuView.bounds.origin.x + value, y: self.sideMenuView.bounds.origin.y
            )
        }
    }
}

extension MainPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.features.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.features[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = featureCollectionView.dequeueReusableCell(
                withReuseIdentifier: MainPageFeatureDefaultsCell.identifier, for: indexPath
            ) as? MainPageFeatureDefaultsCell else {
                return UICollectionViewCell()
            }
            cell.bind(data: viewModel.features[indexPath.section][indexPath.row])
            return cell
        case 1:
            guard let cell = featureCollectionView.dequeueReusableCell(
                withReuseIdentifier: MainPageFeatureListCell.identifier, for: indexPath
            ) as? MainPageFeatureListCell else {
                return UICollectionViewCell()
            }
            cell.bind(data: viewModel.features[indexPath.section][indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        switch indexPath.section {
        case 0:
            return CGSize(width: Constants.screenWidth, height: Constants.defaults.blockHeight * 2)
        case 1:
            return CGSize(width: Constants.screenWidth, height: (Constants.defaults.blockHeight * 4) + (Constants.defaults.vertical * 3) )
        default:
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            print("도감 페이지")
        } else {
            switch indexPath.row {
            case 0:
                let vc = CommunityPageViewController(viewModel: CommunityPageViewModel(), type: .normal)
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = CommunityPageViewController(viewModel: CommunityPageViewModel(), type: .complete)
                self.navigationController?.pushViewController(vc, animated: true)
            default :
                print("default")
            }
        }
    }
}


extension MainPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sideMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.sideMenuItems[indexPath.row].title
//        cell.textLabel?.textColor = .systemGray
        cell.imageView?.image = viewModel.sideMenuItems[indexPath.row].image
        cell.imageView?.tintColor = .systemGray
        cell.contentView.backgroundColor = .systemGray4
        return cell
    }
    
    
}
