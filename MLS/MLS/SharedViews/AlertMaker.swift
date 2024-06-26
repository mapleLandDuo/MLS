//
//  AlertMaker.swift
//  MLS
//
//  Created by SeoJunYoung on 1/23/24.
//

import UIKit

enum AlertMaker {
    /**
     # showAlertAction1
     - Date:
     - Parameters:
     - vc: 알럿을 띄울 뷰컨트롤러
     - preferredStyle: 알럿 스타일
     - title: 알럿 타이틀명
     - message: 알럿 메시지
     - completeTitle: 확인 버튼명
     - completeHandler: 확인 버튼 클릭 시, 실행될 클로저
     - Returns:
     - Note: 버튼이 1개인 알럿을 띄우는 함수
     */
    static func showAlertAction1(vc: UIViewController?, preferredStyle: UIAlertController.Style = .alert, title: String? = "", message: String? = "", completeTitle: String = "확인", _ completeHandler: (() -> Void)? = nil) {
        guard let currentVc = vc else {
            completeHandler?()
            return
        }
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
            
            let completeAction = UIAlertAction(title: completeTitle, style: .default) { _ in
                completeHandler?()
            }
            
            alert.addAction(completeAction)
            
            currentVc.present(alert, animated: true, completion: nil)
        }
    }
    
    /**
     # showAlertAction2
     - Date:
     - Parameters:
     - vc: 알럿을 띄울 뷰컨트롤러
     - preferredStyle: 알럿 스타일
     - title: 알럿 타이틀명
     - message: 알럿 메시지
     - cancelTitle: 취소 버튼명
     - completeTitle: 확인 버튼명
     - cancelHandler: 취소 버튼 클릭 시, 실행될 클로저
     - completeHandler: 확인 버튼 클릭 시, 실행될 클로저
     - Returns:
     - Note: 버튼이 2개인 알럿을 띄우는 함수
     */
    static func showAlertAction2(vc: UIViewController?, preferredStyle: UIAlertController.Style = .alert, title: String? = "", message: String? = "", cancelTitle: String = "취소", completeTitle: String = "확인", _ cancelHandler: (() -> Void)? = nil, _ completeHandler: (() -> Void)? = nil) {
        guard let currentVc = vc else {
            completeHandler?()
            return
        }
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
            
            let cancelAction = UIAlertAction(title: cancelTitle, style: .destructive) { _ in
                cancelHandler?()
            }
            let completeAction = UIAlertAction(title: completeTitle, style: .default) { _ in
                completeHandler?()
            }
            
            alert.addAction(cancelAction)
            alert.addAction(completeAction)
            
            currentVc.present(alert, animated: true, completion: nil)
        }
    }
    
    /**
     # showAlertAction3
     - Date:
     - Parameters:
     - vc: 알럿을 띄울 뷰컨트롤러
     - preferredStyle: 알럿 스타일
     - title: 알럿 타이틀명
     - message: 알럿 메시지
     - cancelTitle: 취소 버튼명
     - completeTitle: 확인 버튼명
     - destructiveTitle: 삭제 버튼명
     - cancelHandler: 취소 버튼 클릭 시, 실행될 클로저
     - completeHandler: 확인 버튼 클릭 시, 실행될 클로저
     - destructiveHandler: 삭제 버튼 클릭 시, 실행될 클로저
     - Returns:
     - Note: 버튼이 3개인 알럿을 띄우는 함수
     */
    static func showAlertAction3(vc: UIViewController?, preferredStyle: UIAlertController.Style = .alert, title: String? = "", message: String? = "", cancelTitle: String = "취소", completeTitle: String = "확인", destructiveTitle: String = "삭제", _ cancelHandler: (() -> Void)? = nil, _ completeHandler: (() -> Void)? = nil, _ destructiveHandler: (() -> Void)? = nil) {
        guard let currentVc = vc else {
            completeHandler?()
            return
        }
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
            
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
                cancelHandler?()
            }
            let destructiveAction = UIAlertAction(title: destructiveTitle, style: .destructive) { _ in
                cancelHandler?()
            }
            let completeAction = UIAlertAction(title: completeTitle, style: .default) { _ in
                completeHandler?()
            }
            
            alert.addAction(cancelAction)
            alert.addAction(destructiveAction)
            alert.addAction(completeAction)
            
            currentVc.present(alert, animated: true, completion: nil)
        }
    }
}
