//
//  ProfilePageViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 1/30/24.
//

import Foundation
import UIKit
import SnapKit

class ProfilePageViewController: BasicController {
    // MARK: - Property
    private let viewModel: ProfilePageViewModel

    // MARK: - Components
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "temp"
        label.font = Typography.title1.font
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "ghd**********"
        label.textColor = .systemGray4
        label.font = Typography.title3.font
        return label
    }()
    
    private let nickNameSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        return view
    }()
    
    private let writtenPostLabel: UILabel = {
        let label = UILabel()
        label.text = "작성한 게시글"
        label.font = Typography.title2.font
        return label
    }()
    
    private let writtenSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    private let postTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = .red
        return view
    }()

    init(viewModel: ProfilePageViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfilePageViewController {
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}
private extension ProfilePageViewController {
    // MARK: - SetUp

    func setUp() {
        setUpConstraints()
    }
    
    func setUpConstraints() {
        view.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.bottom.equalTo(nickNameLabel.snp.bottom)
            make.left.equalTo(nickNameLabel.snp.right).offset(Constants.defaults.horizontal)
        }
        view.addSubview(nickNameSeparator)
        nickNameSeparator.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(Constants.defaults.horizontal)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.height.equalTo(1)
        }
        view.addSubview(writtenPostLabel)
        writtenPostLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameSeparator.snp.bottom).offset(Constants.defaults.vertical)
            make.left.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        view.addSubview(writtenSeparator)
        writtenSeparator.snp.makeConstraints { make in
            make.top.equalTo(writtenPostLabel.snp.bottom).offset(Constants.defaults.horizontal)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.height.equalTo(1)
        }
        view.addSubview(postTableView)
        postTableView.snp.makeConstraints { make in
            make.top.equalTo(writtenSeparator.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
