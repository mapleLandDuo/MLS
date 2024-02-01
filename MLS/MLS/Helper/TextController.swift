//
//  TextController.swift
//  MLS
//
//  Created by SeoJunYoung on 2/2/24.
//

import Foundation
import UIKit
import SnapKit

class TextController: BasicController {
    // MARK: - Property
    private let text: String
    
    // MARK: - Components
    
    lazy var textView: UITextView = {
        let view = UITextView()
        view.text = text
        view.isEditable = false
        view.isUserInteractionEnabled = false
        return view
    }()

    init(text: String) {
        self.text = text
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TextController {
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraints()
    }

}

private extension TextController {
    // MARK: - SetUp
    func setUpConstraints() {
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.defaults.vertical)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Constants.defaults.horizontal)
        }
    }
}
