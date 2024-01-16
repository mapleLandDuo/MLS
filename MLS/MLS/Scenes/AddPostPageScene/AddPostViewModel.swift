//
//  AddPostViewModel.swift
//  MLS
//
//  Created by SeoJunYoung on 1/15/24.
//

import UIKit

class AddPostViewModel {
    let imageData:Observable<[UIImage?]> = Observable([])
    let tempType: Bool
    
    init(tempType: Bool) {
        self.tempType = tempType
    }
}
