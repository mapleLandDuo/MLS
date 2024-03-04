//
//  IndicatorManager.swift
//  MLS
//
//  Created by SeoJunYoung on 3/5/24.
//

import UIKit

import SnapKit

class IndicatorManager {
    static let indicatorImageView: UIImageView = {
        let view = UIImageView()
        guard let gifURL = Bundle.main.url(forResource: "indicator", withExtension: "gif"),
              let gifData = try? Data(contentsOf: gifURL),
              let source = CGImageSourceCreateWithData(gifData as CFData, nil)
        else { return view }
        let frameCount = CGImageSourceGetCount(source)
        var images = [UIImage]()

        (0..<frameCount)
            .compactMap { CGImageSourceCreateImageAtIndex(source, $0, nil) }
            .forEach { images.append(UIImage(cgImage: $0)) }

        view.animationImages = images
        view.animationDuration = TimeInterval(frameCount) * 0.02
        view.animationRepeatCount = 0
        return view
    }()
    
    static func showIndicator(vc: BasicController) {
        vc.view.addSubview(indicatorImageView)
        indicatorImageView.snp.makeConstraints {
            $0.width.equalTo(140)
            $0.height.equalTo(78)
            $0.center.equalToSuperview()
        }
        vc.view.isUserInteractionEnabled = false
        indicatorImageView.startAnimating()
    }
    
    static func hideIndicator(vc: BasicController) {
        indicatorImageView.stopAnimating()
        indicatorImageView.removeFromSuperview()
        vc.view.isUserInteractionEnabled = true
    }
}
