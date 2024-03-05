//
//  LaunchViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 3/5/24.
//

import UIKit

import SnapKit

class LaunchViewController: BasicController {
    
    // MARK: - Properties
    
    private let rootVC: BasicController
    
    // MARK: - Components

    
    private let launchImageView: UIImageView = {
        let view = UIImageView()
        guard let gifURL = Bundle.main.url(forResource: "launchScreen", withExtension: "gif"),
              let gifData = try? Data(contentsOf: gifURL),
              let source = CGImageSourceCreateWithData(gifData as CFData, nil)
        else { return view }
        let frameCount = CGImageSourceGetCount(source)
        var images = [UIImage]()

        (0..<frameCount)
            .compactMap { CGImageSourceCreateImageAtIndex(source, $0, nil) }
            .forEach { images.append(UIImage(cgImage: $0)) }

        view.animationImages = images
        view.animationDuration = 2
        view.animationRepeatCount = 1
        return view
    }()
    
    init(rootVC: BasicController) {
        self.rootVC = rootVC
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - LifeCycle
extension LaunchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

// MARK: - SetUp
private extension LaunchViewController {
    
    func setUp() {
        setUpConstraints()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigationController?.pushViewController(self.rootVC, animated: true)
        }
    }
    
    func setUpConstraints() {
        view.addSubview(launchImageView)
        launchImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        launchImageView.startAnimating()
    }
}



