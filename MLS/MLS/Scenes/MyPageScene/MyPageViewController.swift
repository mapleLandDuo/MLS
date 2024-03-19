//
//  MyPageViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 3/1/24.
//

import UIKit

import SnapKit

protocol MyPageViewControllerDelegate: BasicController {
    func didTapSecessionButton()
}

class MyPageViewController: BasicController {
    // MARK: - Properties
    private var user: User
    weak var delegate: MyPageViewControllerDelegate?
    
    // MARK: - Components
    
    private let topBackGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .themeColor(color: .brand_primary, value: .value_50)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .customFont(fontSize: .heading_md, fontType: .semiBold)
        label.textColor = .semanticColor.text.primary
        label.addCharacterSpacing()
        label.text = "어서오세요\n??? 님"
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = user.id
        label.font = .customFont(fontSize: .body_sm, fontType: .medium)
        label.textColor = .semanticColor.text.secondary
        label.addCharacterSpacing()
        return label
    }()
    
    private let infoBoxView: UIView = {
        let view = UIView()
        view.backgroundColor = .themeColor(color: .base, value: .value_white)
        view.layer.borderColor = UIColor.themeColor(color: .brand_primary, value: .value_200)?.cgColor
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        return view
    }()
    
    private let levelStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = Constants.spacings.sm
        return view
    }()
    
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.text = "레벨"
        label.font = .customFont(fontSize: .body_sm, fontType: .medium)
        label.textColor = .semanticColor.text.primary
        label.addCharacterSpacing()
        return label
    }()
    
    lazy var levelValueLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .heading_sm, fontType: .semiBold)
        label.textColor = .semanticColor.text.info_bold
        label.addCharacterSpacing()
        label.text = String(user.level ?? 0)
        return label
    }()
    
    private let jobStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = Constants.spacings.sm
        return view
    }()
    
    private let jobLabel: UILabel = {
        let label = UILabel()
        label.text = "직업"
        label.font = .customFont(fontSize: .body_sm, fontType: .medium)
        label.textColor = .semanticColor.text.primary
        label.addCharacterSpacing()
        return label
    }()
    
    lazy var jobValueLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .heading_sm, fontType: .semiBold)
        label.textColor = .semanticColor.text.info_bold
        label.addCharacterSpacing()
        label.text = (user.job?.rawValue ?? "미설정")
        return label
    }()
    
    private let infoStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = Constants.spacings.xl
        return view
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let editButtonLabel: UILabel = {
        let label = UILabel()
        label.text = "수정하기"
        label.font = .customFont(fontSize: .body_sm, fontType: .medium)
        label.textColor = .semanticColor.text.primary
        return label
    }()
    
    private let editButtonImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "thinArrowRightIcon")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let emptyImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "fixIllustration")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let emptyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "컨텐츠 준비중이에요"
        label.font = .customFont(fontSize: .body_lg, fontType: .semiBold)
        label.textColor = .semanticColor.text.secondary
        return label
    }()
    
    private let secessionButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원탈퇴", for: .normal)
        button.setTitleColor(.semanticColor.text.secondary, for: .normal)
        button.titleLabel?.font = .customFont(fontSize: .caption_lg, fontType: .regular)
        let attributedString = NSMutableAttributedString.init(string: "회원탈퇴")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: .init(location: 0, length: attributedString.length))
        button.titleLabel?.attributedText = attributedString
        return button
    }()
    
    private let logOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.semanticColor.text.info_bold, for: .normal)
        button.titleLabel?.font = .customFont(fontSize: .caption_lg, fontType: .regular)
        let attributedString = NSMutableAttributedString.init(string: "로그아웃")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: .init(location: 0, length: attributedString.length))
        button.titleLabel?.attributedText = attributedString
        return button
    }()
    
    init(user: User) {
        self.user = user
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - LifeCycle
extension MyPageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let email = LoginManager.manager.email else { return }
        FirebaseManager.firebaseManager.fetchUserData(userEmail: email) { [weak self] user in
            self?.user = user
            let fullText = "어서오세요\n\(user.nickName) 님"
            let attribtuedString = NSMutableAttributedString(string: fullText)
            let range = (fullText as NSString).range(of: user.nickName)
            attribtuedString.addAttribute(.foregroundColor, value: UIColor.semanticColor.text.interactive.primary ?? UIColor.black, range: range)
            self?.titleLabel.attributedText = attribtuedString
            self?.levelValueLabel.text = String(user.level ?? 0)
            if user.job == nil {
                self?.jobValueLabel.text = "미설정"
            } else {
                self?.jobValueLabel.text = user.job?.rawValue
            }
            self?.emailLabel.text = user.id
        }
    }
}

// MARK: - SetUp
private extension MyPageViewController {
    
    func setUp() {
        setUpConstraints()
        setUpNavigation(title: "")
        setUpAddAction()
    }
    
    func setUpAddAction() {
        editButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            let vc = MyPageEditViewController(viewModel: MyPageEditViewModel(user: self.user))
            self.navigationController?.pushViewController(vc, animated: true)
        }), for: .primaryActionTriggered)
        
        secessionButton.addAction(UIAction(handler: { [weak self] _ in
            let vc = MyPageBottomViewController(type: .secession)
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = self
            vc.delegate = self
            self?.present(vc, animated: true)
        }), for: .primaryActionTriggered)
        
        logOutButton.addAction(UIAction(handler: { [weak self] _ in
            let vc = MyPageBottomViewController(type: .logout)
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = self
            vc.delegate = self
            self?.present(vc, animated: true)
        }), for: .primaryActionTriggered)
    }
    
    func setUpConstraints() {
        view.addSubview(topBackGroundView)
        topBackGroundView.addSubview(titleLabel)
        topBackGroundView.addSubview(emailLabel)
        topBackGroundView.addSubview(infoBoxView)
        topBackGroundView.addSubview(editButton)
        editButton.addSubview(editButtonLabel)
        editButton.addSubview(editButtonImageView)
        levelStackView.addArrangedSubview(levelLabel)
        levelStackView.addArrangedSubview(levelValueLabel)
        jobStackView.addArrangedSubview(jobLabel)
        jobStackView.addArrangedSubview(jobValueLabel)
        infoStackView.addArrangedSubview(levelStackView)
        infoStackView.addArrangedSubview(jobStackView)
        infoBoxView.addSubview(infoStackView)
        view.addSubview(emptyImageView)
        view.addSubview(emptyTitleLabel)
        view.addSubview(secessionButton)
        view.addSubview(logOutButton)
        
        topBackGroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(500)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.spacings.xl_3)
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.spacings.xs)
            $0.centerX.equalToSuperview()
        }
        
        infoBoxView.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(Constants.spacings.xl_3)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.height.equalTo(Constants.spacings.xl * 3)
        }
        
        infoStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        editButton.snp.makeConstraints {
            $0.top.equalTo(infoBoxView.snp.bottom).offset(Constants.spacings.lg)
            $0.trailing.equalToSuperview().inset(Constants.spacings.xl)
        }
        
        editButtonLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.height.equalTo(22)
        }
        
        editButtonImageView.snp.makeConstraints {
            $0.leading.equalTo(editButtonLabel.snp.trailing).offset(Constants.spacings.sm)
            $0.trailing.equalToSuperview()
            $0.size.equalTo(Constants.spacings.xl)
            $0.centerY.equalTo(editButton.snp.centerY)
        }
        
        emptyImageView.snp.makeConstraints {
            $0.top.equalTo(topBackGroundView.snp.bottom).offset(Constants.spacings.xl_5)
            $0.size.equalTo(60)
            $0.centerX.equalToSuperview()
        }
        
        emptyTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emptyImageView.snp.bottom).offset(Constants.spacings.sm)
        }
        
        logOutButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(46)
        }
        
        secessionButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(46)
        }
    }
}

extension MyPageViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting, size: 24 + 152 + 34)
    }
}

extension MyPageViewController: MyPageBottomViewControllerDelegate {
    func didTapApplyButton(type: MyPageBottomControllerTypeEnum) {
        switch type {
        case .logout:
            navigationController?.popViewController(animated: true)
        case .secession:
            delegate?.didTapSecessionButton()
            navigationController?.popViewController(animated: true)
        }
    }
}
