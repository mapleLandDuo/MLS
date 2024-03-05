//
//  BasicController.swift
//  MLS
//
//  Created by SeoJunYoung on 1/14/24.
//

import UIKit

import SnapKit

class BasicController: UIViewController {
   
    init() {
        super.init(nibName: nil, bundle: nil)
        print(self, "init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print(self, "deinit")
    }
}

// MARK: - LifeCycle
extension BasicController {
    
    override func viewDidLoad() {
        setUpColor()
    }
}

// MARK: - SetUp
private extension BasicController {

    func setUpColor() {
        view.backgroundColor = .systemBackground
    }
}

// MARK: - Methods

extension BasicController {
    
    func showLaunchScreen(completion: @escaping () -> Void) {
        let launchImageView: UIImageView = {
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
        
        view.addSubview(launchImageView)
        launchImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        launchImageView.startAnimating()
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            launchImageView.removeFromSuperview()
            launchImageView.stopAnimating()
            completion()
        }
    }
}

