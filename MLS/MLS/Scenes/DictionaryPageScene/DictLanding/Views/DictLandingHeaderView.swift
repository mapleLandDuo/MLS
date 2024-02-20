//
//  DictLandingHeaderView.swift
//  MLS
//
//  Created by SeoJunYoung on 2/18/24.
//

import UIKit

import SnapKit

protocol DictLandingHeaderViewDelegate: BasicController {
    func didTapInquireButton()
    func didTapJobBadgeButton()
    func didTapMyPageButton()
}

class DictLandingHeaderView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: DictLandingHeaderViewDelegate?
    
    // MARK: - Components

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .equalSpacing
        view.alignment = .center
        return view
    }()
    
    private let rightStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 8
        return view
    }()
    
    private let jobBadgeButton = JobBadgeButton(job: "전사", level: "56")
    
    private let myPageIconButton = MyPageIconButton()
    
    private let inquireButton = InquireButton()
    
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
private extension DictLandingHeaderView {
    func setUp() {
        setUpConstraints()
        setUpAddAction()
    }
    
    func setUpAddAction() {
        jobBadgeButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.didTapJobBadgeButton()
        }), for: .primaryActionTriggered)
        myPageIconButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.didTapMyPageButton()
        }), for: .primaryActionTriggered)
        inquireButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.didTapInquireButton()
        }), for: .primaryActionTriggered)
    }
    
    func setUpConstraints() {
        self.addSubview(stackView)
        rightStackView.addArrangedSubview(jobBadgeButton)
        rightStackView.addArrangedSubview(myPageIconButton)
        stackView.addArrangedSubview(inquireButton)
        stackView.addArrangedSubview(rightStackView)
        
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.spacings.md)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
        }
    }
}
