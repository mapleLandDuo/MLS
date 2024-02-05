//
//  BasicController.swift
//  MLS
//
//  Created by SeoJunYoung on 1/14/24.
//

import UIKit

class BasicController: UIViewController {
   
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

// MARK: - LifeCycle
extension BasicController {
    
    override func viewDidLoad() {
        setUpColor()
    }
}

// MARK: - SetUp
private extension BasicController {

    func setUpColor() {
        view.backgroundColor = .systemBackground
    }
}
