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

// MARK: - Life Cycle
extension AppInfoPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

// MARK: - SetUp
private extension AppInfoPageViewController {

    func setUp() {
        setUpConstraints()
    }
    
    func setUpConstraints() {
        
        view.addSubview(titleLabel)
        view.addSubview(titleSeparatorView)
        view.addSubview(appIconImageView)
        view.addSubview(appNameLabel)
        view.addSubview(appVersionLabel)
        view.addSubview(titleBottomSeparatorView)
        view.addSubview(makerLabel)
        view.addSubview(makerSeparatorView)
        view.addSubview(makerDescriptionLabel)
        
        titleLabel.snp.makeConstraints { 
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }

        titleSeparatorView.snp.makeConstraints { 
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.height.equalTo(1)
        }

        appIconImageView.snp.makeConstraints { 
            $0.top.equalTo(titleSeparatorView.snp.bottom).offset(Constants.defaults.vertical)
            $0.leading.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.height.width.equalTo(Constants.screenWidth / 6)
        }

        appNameLabel.snp.makeConstraints { 
            $0.leading.equalTo(appIconImageView.snp.trailing).offset(Constants.defaults.horizontal)
            $0.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.bottom.equalTo(appIconImageView.snp.centerY).inset(Constants.defaults.vertical)
        }

        appVersionLabel.snp.makeConstraints { 
            $0.leading.equalTo(appIconImageView.snp.trailing).offset(Constants.defaults.horizontal)
            $0.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.top.equalTo(appIconImageView.snp.centerY).offset(Constants.defaults.vertical / 2)
        }

        titleBottomSeparatorView.snp.makeConstraints { 
            $0.top.equalTo(appIconImageView.snp.bottom).offset(Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.height.equalTo(1)
        }

        makerLabel.snp.makeConstraints { 
            $0.top.equalTo(titleBottomSeparatorView.snp.bottom).offset(Constants.defaults.vertical)
            $0.leading.equalToSuperview().inset(Constants.defaults.horizontal)
        }

        makerSeparatorView.snp.makeConstraints { 
            $0.top.equalTo(makerLabel.snp.bottom).offset(Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.height.equalTo(1)
        }

        makerDescriptionLabel.snp.makeConstraints { 
            $0.top.equalTo(makerSeparatorView.snp.bottom).offset(Constants.defaults.vertical)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }
    }
}
