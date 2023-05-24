//
//  StepperValueCell.swift
//  iOS UIKit
//
//  Created by 이준복 on 2023/05/23.
//

import Foundation
import RxSwift

final class StepperValueCell: DefaultTextFieldCell, StepperSettingListCellProtocol {
    
    static override var cellId: String {
        StepperValueCellConstants.cellId
    }
    
    private var valueTypeStream: Observable<StepperValueType> = Observable.just(.step)
    
    func setup(_ item: StepperSettingListItemType) {
        guard case let .value(valueType: valueType) = item else { return }
        self.valueTypeStream = Observable.just(valueType)
        textField.placeholder = valueType.rawValue
        textField.keyboardType = .decimalPad
    }
    
    func bind(_ viewModel: StepperViewModel) {
        textField.rx.text
            .compactMap { Double($0 ?? "") }
            .withLatestFrom(valueTypeStream) { value, valueType in
                StepperValue(valueType: valueType, value: value)
            }
            .distinctUntilChanged()
            .bind(onNext: { [weak viewModel] stepperValue in
                viewModel?.valueCellDidChanged(stepperValue)
            })
            .disposed(by: disposeBag)
    }
    
}
