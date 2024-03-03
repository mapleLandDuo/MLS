//
//  MyPageEditViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 3/1/24.
//

import UIKit

import SnapKit

class MyPageEditViewController: BasicController {
    // MARK: - Properties
    private let viewModel: MyPageEditViewModel
    
    // MARK: - Components
    
    private let nickNameTextField = CustomTextField(type: .normal, header: "닉네임", placeHolder: "test")
    
    private let levelTextField = CustomTextField(type: .normal, header: "레벨", placeHolder: "test")

    private let jobTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontSize: .body_sm, fontType: .medium)
        label.textColor = .semanticColor.text.primary
        label.text = "직업"
        label.addCharacterSpacing()
        return label
    }()
    
    private let jobCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.spacings.md
        layout.sectionInset = .init(top: 0, left: Constants.spacings.xl, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        let width = (Constants.screenWidth - (Constants.spacings.xl * 2) - (Constants.spacings.md * 3)) / 4
        layout.itemSize = .init(width: width, height: 48)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("수정하기", for: .normal)
        button.backgroundColor = .semanticColor.bg.disabled
        button.layer.cornerRadius = 12
        button.setTitleColor(.semanticColor.text.interactive.secondary, for: .disabled)
        button.titleLabel?.font = .customFont(fontSize: .body_md, fontType: .semiBold)
        button.titleLabel?.addCharacterSpacing()
        return button
    }()
    
    init(viewModel: MyPageEditViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - LifeCycle
extension MyPageEditViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        nickNameTextField.textField.delegate = self
    }
}

// MARK: - SetUp
private extension MyPageEditViewController {
    
    func setUp() {
        setUpConstraints()
        setUpNavigation()
        jobCollectionView.delegate = self
        jobCollectionView.dataSource = self
        jobCollectionView.register(DictSearchJobButtonCell.self, forCellWithReuseIdentifier: DictSearchJobButtonCell.identifier)
    }
    
    func setUpConstraints() {
        view.addSubview(nickNameTextField)
        view.addSubview(levelTextField)
        view.addSubview(jobTitleLabel)
        view.addSubview(jobCollectionView)
        view.addSubview(editButton)
        
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.spacings.xl_3)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
        }
        
        levelTextField.snp.makeConstraints {
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(Constants.spacings.xl_2)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
        }
        
        jobTitleLabel.snp.makeConstraints {
            $0.top.equalTo(levelTextField.snp.bottom).offset(Constants.spacings.xl_2)
            $0.leading.equalToSuperview().inset(Constants.spacings.xl)
        }
        
        jobCollectionView.snp.makeConstraints {
            $0.top.equalTo(jobTitleLabel.snp.bottom).offset(Constants.spacings.xs)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        editButton.snp.makeConstraints {
            $0.top.equalTo(jobCollectionView.snp.bottom).offset(Constants.spacings.xl_5)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.height.equalTo(Constants.spacings.xl_4)
        }
    }
    
    func setUpNavigation() {
        let spacer = UIBarButtonItem()
        let image = UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysTemplate)
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTapBackButton))
        backButton.tintColor = .themeColor(color: .base, value: .value_black)
        navigationItem.leftBarButtonItems = [spacer, backButton]
        navigationController?.navigationBar.isHidden = false
    }
}

// MARK: - Methods
private extension MyPageEditViewController {
    @objc
    func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyPageEditViewController: UITextFieldDelegate {
    
}

extension MyPageEditViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Job.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DictSearchJobButtonCell.identifier, for: indexPath) as? DictSearchJobButtonCell else { return UICollectionViewCell() }
        cell.bind(job: Job.allCases[indexPath.row].rawValue)
        return cell
    }
}
