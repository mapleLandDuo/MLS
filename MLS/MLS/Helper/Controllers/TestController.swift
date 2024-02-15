//
//  TestController.swift
//  MLS
//
//  Created by SeoJunYoung on 2/14/24.
//

import Foundation

class TestController: BasicController {
    
}

extension TestController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        print(DBHelper.shared.readData())
        
    }
}
