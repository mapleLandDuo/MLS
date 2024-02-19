//
//  MyPageIconButton.swift
//  MLS
//
//  Created by SeoJunYoung on 2/18/24.
//

import UIKit

import SnapKit

class MyPageIconButton: UIButton {
    // MARK: - Components
    
    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "mypageIcon")
        view.contentMode = .scaleAspectFill
        return view
    }()

    init() {
        super.init(frame: .zero)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension MyPageIconButton {
    func setUp() {
        setUpConstraints()
    }
    
    func setUpConstraints() {

        self.addSubview(iconImageView)
        
        self.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        iconImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(6)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xs_3)
        }
    }
}
