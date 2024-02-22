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
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
//    private let backButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
//        button.tintColor = .semanticColor.icon.primary
//        return button
//    }()
    

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
    }
}

// MARK: - SetUp
private extension DictSearchViewController {
    func setUp() {
        setUpNavigation()
//        backButton.addAction(UIAction(handler: { [weak self] _ in
//            self?.navigationController?.popViewController(animated: true)
//        }), for: .primaryActionTriggered)
    }
    
    func setUpNavigation() {
        
        
        self.navigationItem.titleView = searchBar
        self.navigationController?.navigationBar.tintColor = .semanticColor.icon.primary
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
}
