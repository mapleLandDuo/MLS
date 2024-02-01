//
//  BasicController.swift
//  MLS
//
//  Created by SeoJunYoung on 1/14/24.
//

import UIKit

class BasicController: UIViewController {
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        setUpColor()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        print(self, "init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print(self, "deinit")
    }
}

private extension BasicController {
    // MARK: - SetUp
    private func setUpColor() {
        view.backgroundColor = .systemBackground
    }
}
