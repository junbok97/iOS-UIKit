//
//  CodeTextViewCell.swift
//  iOS UIKit
//
//  Created by 이준복 on 2023/05/10.
//

import UIKit
import RxSwift

final class LabelCodeCell: DefaultCodeCell, LabelSettingListCellProtocol {
    static override var cellId: String { LabelCodeCellConstants.cellId }
    
    func setup(_ item: LabelSettingListItemType) { }

    func bind(_ viewModel: LabelViewModelProtocol) {
        viewModel.codeCellCodeLabelText
            .drive(self.rx.codeText)
            .disposed(by: disposeBag)
    }
}
