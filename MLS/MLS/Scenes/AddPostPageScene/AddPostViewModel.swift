//
//  AddPostViewModel.swift
//  MLS
//
//  Created by SeoJunYoung on 1/15/24.
//

import UIKit

class AddPostViewModel {
    let imageData:Observable<[UIImage?]> = Observable([])
    let type: BoardSeparatorType
    
    init(type: BoardSeparatorType) {
        self.type = type
    }
}
