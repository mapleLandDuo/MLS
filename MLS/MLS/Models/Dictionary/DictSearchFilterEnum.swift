//
//  DictSearchFilterEnum.swift
//  MLS
//
//  Created by SeoJunYoung on 2/28/24.
//

import Foundation

enum DictSearchFilterEnum: CaseIterable {
    case job
    case levelRange
    
    var cellHeight: CGFloat {
        switch self {
        case .job:
            return Constants.spacings.xl + Constants.spacings.sm + 48 + Constants.spacings.xl_2
        case .levelRange:
            return Constants.spacings.xl + Constants.spacings.sm + Constants.spacings.xl_3 + Constants.spacings.xl_2
        }
    }
}

struct DictSearchFilter {
    var job: String?
    var levelRange: (Int, Int)?
}
