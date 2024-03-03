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
    private let viewModel: MyPageViewModel
    
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
        label.text = "어서오세요\nnickName 님"
        label.font = .customFont(fontSize: .heading_md, fontType: .semiBold)
        label.textColor = .semanticColor.text.primary
        label.addCharacterSpacing()
//        label.at
//        let fullText = data.title
//        let attribtuedString = NSMutableAttributedString(string: fullText)
//        let range = (fullText as NSString).range(of: keyword)
//        attribtuedString.addAttribute(.foregroundColor, value: UIColor.semanticColor.text.interactive.primary, range: range)
//        nameLabel.attributedText = attribtuedString
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "abc123@naver.com"
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
    
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.text = "레벨  LV"
        label.font = .customFont(fontSize: .body_sm, fontType: .medium)
        label.textColor = .semanticColor.text.primary
        label.addCharacterSpacing()
        label.textAlignment = .right
        return label
    }()
    
    private let jobLabel: UILabel = {
        let label = UILabel()
        label.text = "직업  Job"
        label.font = .customFont(fontSize: .body_sm, fontType: .medium)
        label.textColor = .semanticColor.text.primary
        label.addCharacterSpacing()
        return label
    }()
    
    private let infoStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = Constants.spacings.xl
        view.distribution = .fillEqually
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
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
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
}

// MARK: - SetUp
private extension MyPageViewController {
    
    func setUp() {
        setUpConstraints()
        setUpNavigation()
        setUpAddAction()
    }
    
    func setUpNavigation() {
        let spacer = UIBarButtonItem()
        let image = UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysTemplate)
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTapBackButton))
        backButton.tintColor = .themeColor(color: .base, value: .value_black)
        navigationItem.leftBarButtonItems = [spacer, backButton]
        navigationController?.navigationBar.isHidden = false
    }
    
    func setUpAddAction() {
        editButton.addAction(UIAction(handler: { [weak self] _ in
            let vc = MyPageEditViewController(viewModel: MyPageEditViewModel())
            self?.navigationController?.pushViewController(vc, animated: true)
        }), for: .primaryActionTriggered)
        
        secessionButton.addAction(UIAction(handler: { [weak self] _ in
            let vc = MyPageSecessionViewController()
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
        infoStackView.addArrangedSubview(levelLabel)
        infoStackView.addArrangedSubview(jobLabel)
        infoBoxView.addSubview(infoStackView)
        view.addSubview(emptyImageView)
        view.addSubview(emptyTitleLabel)
        view.addSubview(secessionButton)
        
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
            $0.edges.equalToSuperview().inset(Constants.spacings.xl)
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
        
        secessionButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Constants.spacings.xl)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.spacings.xl)
        }
    }
}
// MARK: - Methods
private extension MyPageViewController {
    @objc
    func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyPageViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting, size: 24 + 152 + 34)
    }
}

extension MyPageViewController: MyPageSecessionViewControllerDelegate {
    func didTapApplyButton() {
        delegate?.didTapSecessionButton()
        navigationController?.popViewController(animated: true)
    }
}
