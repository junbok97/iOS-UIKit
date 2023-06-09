//
//  ObjectListData.swift
//  iOS UIKit
//
//  Created by 이준복 on 2023/05/19.
//

import Foundation

struct ObjectListData {
    static let objectListDatas: [ObjectSectionModel] = [
        ObjectSectionModel(
            sectionHeader: .Views,
            items: [
                .uiLabel,
                .uiStackView
            ]
        ),
        ObjectSectionModel(
            sectionHeader: .controls,
            items: [
                .uiButton,
                .uiSwitch,
                .uiStepper,
                .uiSlider
            ]
        ),
        ObjectSectionModel(
            sectionHeader: .system,
            items: [
                .sfSymbols
            ]
        )
    ]
}
