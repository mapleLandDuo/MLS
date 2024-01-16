//
//  AddPostViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 1/15/24.
//

import UIKit
import SnapKit
import PhotosUI

class AddPostViewController: BasicController {
    // MARK: - Property
    private let viewModel: AddPostViewModel

    // MARK: - Components

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let imageChoiceCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: Constants.defaults.blockHeight * 2, height: Constants.defaults.blockHeight * 2)
        layout.minimumLineSpacing = Constants.defaults.horizontal
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.font = Typography.title3.font
        return label
    }()
    
    private let titleTextField: InsetTextField = {
        let view = InsetTextField()
        view.placeholder = "제목을 입력해 주세요."
        view.font = Typography.body1.font
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = Constants.defaults.radius
        return view
    }()
    
    private let postLabel: UILabel = {
        let label = UILabel()
        label.text = "내용"
        label.font = Typography.title3.font
        return label
    }()
    
    private let postTextView: UITextView = {
        let view = UITextView()
        view.textContainerInset = .init(
            top: Constants.defaults.vertical,
            left: Constants.defaults.horizontal / 2,
            bottom: Constants.defaults.horizontal / 2,
            right: Constants.defaults.vertical
        )
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = Constants.defaults.radius
        view.font = Typography.body1.font
        return view
    }()

    private let postButton: UIButton = {
        let button = UIButton()
        button.setTitle("작성 완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Typography.button.font
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = Constants.defaults.radius
        return button
    }()
    
    lazy var tradeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "거래 방식"
        label.font = Typography.title3.font
        return label
    }()
    
    lazy var segmentedController: UISegmentedControl = {
        let view = UISegmentedControl(items: ["팝니다", "삽니다"])
        view.selectedSegmentIndex = 0
        view.tintColor = .systemOrange
        view.setTitleTextAttributes([
            NSAttributedString.Key.font: Typography.button.font,
            NSAttributedString.Key.foregroundColor: UIColor.systemGray
        ], for: .normal)
        view.setTitleTextAttributes([
            NSAttributedString.Key.font: Typography.button.font,
            NSAttributedString.Key.foregroundColor: UIColor.systemBackground
        ], for: .selected)
        view.selectedSegmentTintColor = .systemOrange
        return view
    }()
    
    init(viewModel: AddPostViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddPostViewController {
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
}

private extension AddPostViewController {
    // MARK: - Bind
    func bind() {
        viewModel.imageData.bind { [weak self] _ in
            self?.imageChoiceCollectionView.reloadData()
        }
    }
}

private extension AddPostViewController {
    // MARK: - SetUp
    func setUp() {
        setUpConstraints()
        titleTextField.delegate = self
        postTextView.delegate = self
        imageChoiceCollectionView.dataSource = self
        imageChoiceCollectionView.delegate = self
        imageChoiceCollectionView.register(AddPostImageChoiceCell.self, forCellWithReuseIdentifier: AddPostImageChoiceCell.identifier)
        imageChoiceCollectionView.register(AddPostImageCell.self, forCellWithReuseIdentifier: AddPostImageCell.identifier)
    }
    
    func setUpConstraints() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        contentView.addSubview(imageChoiceCollectionView)
        imageChoiceCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.height.equalTo(Constants.defaults.blockHeight * 2)
        }
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageChoiceCollectionView.snp.bottom).offset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
        }
        contentView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.defaults.vertical / 2)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
        }

        
        if viewModel.tempType {
            contentView.addSubview(postLabel)
            postLabel.snp.makeConstraints { make in
                make.top.equalTo(titleTextField.snp.bottom).offset(Constants.defaults.vertical)
                make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            }
        } else {
            contentView.addSubview(tradeTitleLabel)
            tradeTitleLabel.snp.makeConstraints { make in
                make.top.equalTo(titleTextField.snp.bottom).offset(Constants.defaults.vertical)
                make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            }
            contentView.addSubview(segmentedController)
            segmentedController.snp.makeConstraints { make in
                make.top.equalTo(tradeTitleLabel.snp.bottom).offset(Constants.defaults.vertical)
                make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
                make.height.equalTo(Constants.defaults.blockHeight)
            }
            contentView.addSubview(postLabel)
            postLabel.snp.makeConstraints { make in
                make.top.equalTo(segmentedController.snp.bottom).offset(Constants.defaults.vertical)
                make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            }

        }
        contentView.addSubview(postTextView)
        postTextView.snp.makeConstraints { make in
            make.top.equalTo(postLabel.snp.bottom).offset(Constants.defaults.vertical / 2)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.height.equalTo(Constants.screenHeight * 0.5)
        }
        contentView.addSubview(postButton)
        postButton.snp.makeConstraints { make in
            make.top.equalTo(postTextView.snp.bottom).offset(Constants.defaults.vertical)
            make.left.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.height.equalTo(Constants.defaults.blockHeight)
            make.bottom.equalToSuperview()
        }

    }

}

extension AddPostViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = viewModel.imageData.value?.count else { return 1 }
        return count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = imageChoiceCollectionView.dequeueReusableCell(
                withReuseIdentifier: AddPostImageChoiceCell.identifier, for: indexPath
            ) as? AddPostImageChoiceCell else {
                return UICollectionViewCell()
            }
            cell.bind(count: viewModel.imageData.value?.count)
            return cell
        } else {
            guard let cell = imageChoiceCollectionView.dequeueReusableCell(
                withReuseIdentifier: AddPostImageCell.identifier, for: indexPath
            ) as? AddPostImageCell else {
                return UICollectionViewCell()
            }
            guard let data = viewModel.imageData.value else { return cell }
            cell.bind(image: data[indexPath.row - 1])
            cell.callBackMethod = { [weak self] in
                self?.viewModel.imageData.value?.remove(at: indexPath.row - 1)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 5
            configuration.filter = .any(of: [.images])
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self.present(picker, animated: true)
        }
    }
}

extension AddPostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        self.viewModel.imageData.value = []
        for i in 0..<results.count{
            let itemProvider = results[i].itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self){
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.viewModel.imageData.value!.append(image as? UIImage)
                    }
                }
            }
        }
    }
}

extension AddPostViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.systemOrange.cgColor
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.systemGray4.cgColor
    }
}

extension AddPostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.systemOrange.cgColor
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.systemGray4.cgColor
    }
}
