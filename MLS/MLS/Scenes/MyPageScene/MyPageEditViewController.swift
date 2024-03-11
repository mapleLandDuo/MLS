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
    
    lazy var nickNameTextField = CustomTextField(type: .normal, header: "닉네임", placeHolder: viewModel.fetchUser().nickName)
    
    lazy var levelTextField = CustomTextField(type: .normal, header: "레벨", placeHolder: String(viewModel.fetchUser().level ?? 0))

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
        bind()
        nickNameTextField.textField.delegate = self
        levelTextField.textField.delegate = self
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
        editButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            IndicatorManager.showIndicator(vc: self)
            FirebaseManager.firebaseManager.updateUserData(user: viewModel.user) {
                IndicatorManager.hideIndicator(vc: self)
                self.navigationController?.popViewController(animated: true)
            }
        }), for: .primaryActionTriggered)
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

// MARK: - Bind
private extension MyPageEditViewController {
    func bind() {
        viewModel.nickNameState.bind { [weak self] state in
            guard let state = state else { return }
            if state != .default {
                let isCorrect = state == .complete
                self?.nickNameTextField.checkState(state: state, isCorrect: isCorrect)
            }
            self?.viewModel.isValidButton()
        }
        
        viewModel.levelState.bind { [weak self] state in
            if let state = state {
                if state != .default {
                    let isCorrect = state == .complete
                    self?.levelTextField.checkState(state: state, isCorrect: isCorrect)
                }
            } else {
                self?.levelTextField.footerLabel.isHidden = false
            }
            self?.viewModel.isValidButton()
        }
        viewModel.jobState.bind { [weak self] job in
            self?.viewModel.isValidButton()
        }
        
        viewModel.buttonState.bind { [weak self] state in
            if let state = state {
                if state {
                    self?.editButton.setTitleColor(.themeColor(color: .base, value: .value_white), for: .disabled)
                    self?.editButton.backgroundColor = .semanticColor.bg.interactive.primary
                    self?.editButton.isUserInteractionEnabled = true
                } else {
                    self?.editButton.setTitleColor(.semanticColor.text.interactive.secondary, for: .disabled)
                    self?.editButton.backgroundColor = .semanticColor.bg.disabled
                    self?.editButton.isUserInteractionEnabled = false
                }
            }
        }
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
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if textField == nickNameTextField.textField {
            viewModel.user.nickName = text
            viewModel.checkNickName(nickName: text)
        } else {
            viewModel.user.level = Int(text)
            viewModel.checkLevel(level: text)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == nickNameTextField.textField {
            nickNameTextField.contentView.layer.borderColor = UIColor.semanticColor.bolder.interactive.primary_pressed?.cgColor
        } else {
            levelTextField.contentView.layer.borderColor = UIColor.semanticColor.bolder.interactive.primary_pressed?.cgColor
        }
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField == nickNameTextField.textField {
            nickNameTextField.contentView.layer.borderColor = UIColor.semanticColor.bolder.interactive.secondary?.cgColor
        } else {
            levelTextField.contentView.layer.borderColor = UIColor.semanticColor.bolder.interactive.secondary?.cgColor
        }
        
        return true
    }
}

extension MyPageEditViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Job.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DictSearchJobButtonCell.identifier, for: indexPath) as? DictSearchJobButtonCell else { return UICollectionViewCell() }
        cell.bind(job: Job.allCases[indexPath.row].rawValue)
        
        if let job = viewModel.fetchUser().job {
            if Job.allCases[indexPath.row] == job {
                viewModel.jobState.value = job
                cell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.jobState.value = Job.allCases[indexPath.row]
        viewModel.user.job = Job.allCases[indexPath.row]
    }
}
