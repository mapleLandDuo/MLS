//
//  AnnouncementDatas.swift
//  MLS
//
//  Created by SeoJunYoung on 2/21/24.
//

import Foundation


struct AnnouncementData {
    let number: Int
    let title: String
    let content: String
    let isShow: Bool
}

struct AnnouncementDatas {
    let datas = [
        AnnouncementData(number: 0, title: "test", content: "test", isShow: false),
        AnnouncementData(number: 1, title: "test", content: "test", isShow: false),
        AnnouncementData(number: 2, title: "test", content: "test", isShow: false),
        AnnouncementData(number: 3, title: "test", content: "test", isShow: false),
        AnnouncementData(number: 4, title: "test", content: "test", isShow: false),
        AnnouncementData(number: 5, title: "test", content: "test", isShow: false),
        AnnouncementData(number: 6, title: "test", content: "test", isShow: false),
        AnnouncementData(number: 7, title: "test7", content: "test", isShow: false),
        AnnouncementData(number: 8, title: "test8", content: "test", isShow: false),
        AnnouncementData(number: 9, title: "test9", content: "test", isShow: false)
    ]
}
