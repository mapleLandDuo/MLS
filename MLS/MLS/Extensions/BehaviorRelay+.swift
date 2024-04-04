//
//  BehaviorRelay+.swift
//  MLS
//
//  Created by SeoJunYoung on 3/26/24.
//

import RxCocoa

extension BehaviorRelay where Element: RangeReplaceableCollection {

    func append(element: Element.Element) {
        var array = self.value
        array.append(element)
        self.accept(array)
    }
    
    func remove(index: Element.Index) {
        var array = self.value
        array.remove(at: index)
        self.accept(array)
    }
}

extension BehaviorRelay where Element == [Section] {
    func updateSection(newSection: Section) {
        var currentSections = self.value
        let index = newSection.index

        if let newIndex = currentSections.firstIndex(where: { $0.index == index }) {
            currentSections[newIndex] = newSection
        } else {
            currentSections.append(newSection)
        }
        self.accept(currentSections)
    }
}
