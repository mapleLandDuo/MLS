//
//  DictLandingViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 2/18/24.
//

import UIKit

import SnapKit

class DictLandingViewController: BasicController {
    // MARK: - Properties

    var viewModel: DictLandingViewModel
    
    // MARK: - Components
    
    var headerView = DictLandingHeaderView()
    
    var firstSectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    var secondSectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()

    init(viewModel: DictLandingViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension DictLandingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - SetUp
private extension DictLandingViewController {
    func setUp() {
        setUpConstraints()
    }
    
    func setUpConstraints() {
        view.addSubview(headerView)
        view.addSubview(firstSectionView)
        view.addSubview(secondSectionView)
        
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(56)
        }
        firstSectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(204)
        }
        secondSectionView.snp.makeConstraints {
            $0.top.equalTo(firstSectionView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
