//
//  AppInfoPageViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 1/30/24.
//

import UIKit

import SnapKit

class AppInfoPageViewController: BasicController {
    // MARK: - Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title2.font
        label.text = "앱 정보"
        return label
    }()
    
    private let titleSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        return view
    }()
    
    private let appIconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "AppIcon")
        view.layer.borderWidth = 1
        view.layer.cornerRadius = Constants.defaults.radius
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "메이플 랜드 사전"
        label.font = Typography.body2.font
        return label
    }()
    
    private let appVersionLabel: UILabel = {
        let label = UILabel()
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return label }
        label.text = "앱버전: " + version
        label.font = Typography.body2.font
        return label
    }()
    
    private let titleBottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        return view
    }()
    
    private let makerLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title2.font
        label.text = "만든 사람들"
        label.textColor = .systemGray4
        return label
    }()
    
    private let makerSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    private let makerDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "iOS Developer 서준영\niOS Developer 최진훈"
        label.font = Typography.body2.font
        label.textColor = UIColor.systemGray4
        return label
    }()
}

extension AppInfoPageViewController {
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

private extension AppInfoPageViewController {
    // MARK: - SetUp

    func setUp() {
        setUpConstraints()
    }
    
    func setUpConstraints() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        view.addSubview(titleSeparatorView)
        titleSeparatorView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.height.equalTo(1)
        }
        view.addSubview(appIconImageView)
        appIconImageView.snp.makeConstraints { make in
            make.top.equalTo(titleSeparatorView.snp.bottom).offset(Constants.defaults.vertical)
            make.left.equalToSuperview().inset(Constants.defaults.horizontal)
            make.height.width.equalTo(Constants.screenWidth / 6)
        }
        view.addSubview(appNameLabel)
        appNameLabel.snp.makeConstraints { make in
            make.left.equalTo(appIconImageView.snp.right).offset(Constants.defaults.horizontal)
            make.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.bottom.equalTo(appIconImageView.snp.centerY).inset(Constants.defaults.vertical)
        }
        view.addSubview(appVersionLabel)
        appVersionLabel.snp.makeConstraints { make in
            make.left.equalTo(appIconImageView.snp.right).offset(Constants.defaults.horizontal)
            make.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.top.equalTo(appIconImageView.snp.centerY).offset(Constants.defaults.vertical / 2)
        }
        view.addSubview(titleBottomSeparatorView)
        titleBottomSeparatorView.snp.makeConstraints { make in
            make.top.equalTo(appIconImageView.snp.bottom).offset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.height.equalTo(1)
        }
        view.addSubview(makerLabel)
        makerLabel.snp.makeConstraints { make in
            make.top.equalTo(titleBottomSeparatorView.snp.bottom).offset(Constants.defaults.vertical)
            make.left.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        view.addSubview(makerSeparatorView)
        makerSeparatorView.snp.makeConstraints { make in
            make.top.equalTo(makerLabel.snp.bottom).offset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.height.equalTo(1)
        }
        view.addSubview(makerDescriptionLabel)
        makerDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(makerSeparatorView.snp.bottom).offset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
        }
    }
}
