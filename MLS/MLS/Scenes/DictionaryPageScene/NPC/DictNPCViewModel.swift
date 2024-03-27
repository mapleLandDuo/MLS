//
//  DictNPCViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/03.
//

import Foundation

import RxCocoa

class DictNPCViewModel: DictBaseViewModel {
    // MARK: Properties
    var tabMenus = ["출현 장소", "수락 퀘스트"]

//    var selectedNPC: TempObservable<DictNPC> = TempObservable(nil)
    var selectedNPC = BehaviorRelay<DictNPC?>(value: nil)
}
