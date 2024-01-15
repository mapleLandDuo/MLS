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
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

}

private extension MainPageViewController {
    // MARK: - SetUp

    func setUp() {
        setUpConstraints()
        featureCollectionView.delegate = self
        featureCollectionView.dataSource = self
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
            return CGSize(width: Constants.screenWidth, height: (Constants.defaults.blockHeight * 4) + (Constants.defaults.vertical * 5) )
        default:
            return CGSize()
        }
    }
}
