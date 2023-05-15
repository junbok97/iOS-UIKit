//
//  LabelViewModel.swift
//  UIKit-Test
//
//  Created by 이준복 on 2023/04/13.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class LabelViewModel {
    
    private let disposeBag = DisposeBag()
    
    // View -> ViewModel
    let codeCellCodeLabelText: Driver<String>
    let textCellDidChangedTextField = PublishRelay<String>()
    let colorCellDidSelected = PublishRelay<ObjectColor>()
    let fontCellDidSelected = PublishRelay<ObjectFontType>()
    let fontSizeCellDidChangedFontSizeSlider = PublishRelay<Int>()
    let fontSizeCellSliderText: Driver<Int>
    let alignmentCellDidSelected = PublishRelay<ObjectAlignmentType>()
    let numberOfLinesCellDidChangedLineStepper = PublishRelay<Int>()
    let numberOfLinesCellStepperValueLabelText: Driver<Int>
    let didItemSelectedLabelSettingList = PublishRelay<LabelSettingListItemType>()
    
    // ViewModel -> View
    let targetText: Driver<String>
    let targetFont: Driver<UIFont>
    let targetColor: Driver<ObjectColor>
    let targetAlignment: Driver<ObjectAlignmentType>
    let targetNumberOfLines: Driver<Int>
    let labelSettingListCellDatas: Driver<[LabelSettingListSectionModel]>
    
    
    
    init() {
        let labelModel = LabelModel()
        labelSettingListCellDatas = labelModel.labelSettingListCellDatas
            .asDriver(onErrorDriveWith: .empty())
              
        didItemSelectedLabelSettingList
            .compactMap { labelSettingListSectionItemType -> ObjectFontType? in
                guard case let .font(fontType) = labelSettingListSectionItemType else { return nil }
                return fontType
            }
            .bind(to: fontCellDidSelected)
            .disposed(by: disposeBag)
        
        didItemSelectedLabelSettingList
            .compactMap { labelSettingListSectionItemType -> ObjectAlignmentType? in
                guard case let .alignment(alignmentType) = labelSettingListSectionItemType else { return nil }
                return alignmentType
            }
            .bind(to: alignmentCellDidSelected)
            .disposed(by: disposeBag)
              
        targetText = textCellDidChangedTextField
            .asDriver(onErrorDriveWith: .empty())
        
        targetColor = colorCellDidSelected
            .asDriver(onErrorDriveWith: .empty())
        
        targetFont = Observable
            .combineLatest(fontCellDidSelected, fontSizeCellDidChangedFontSizeSlider) { (fontType, ofSize) -> UIFont in
                fontType.font(ofSize: CGFloat(ofSize))
            }
            .asDriver(onErrorDriveWith: .empty())
        
        fontSizeCellSliderText = fontSizeCellDidChangedFontSizeSlider
            .asDriver(onErrorDriveWith: .empty())
        
        targetAlignment = alignmentCellDidSelected
            .asDriver(onErrorDriveWith: .empty())
        
        targetNumberOfLines = numberOfLinesCellDidChangedLineStepper
            .asDriver(onErrorDriveWith: .empty())
        
        numberOfLinesCellStepperValueLabelText = numberOfLinesCellDidChangedLineStepper
            .asDriver(onErrorDriveWith: .empty())
        
        let textCode = textCellDidChangedTextField
            .startWith(LabelViewControllerConstants.textCode)
        
        let textColorCode = colorCellDidSelected
            .filter { $0.colorType == .textColor }
            .map { "\($0.color)" }
            .startWith(LabelViewControllerConstants.textColorCode)
        
        let backgroundColorCode = colorCellDidSelected
            .filter { $0.colorType == .backgroundColor }
            .map { "\($0.color)" }
            .startWith(LabelViewControllerConstants.backgroundColorCode)
        
        let fontCode = Observable
            .combineLatest(fontCellDidSelected, fontSizeCellDidChangedFontSizeSlider) { font, ofSize in
                font.code(ofSize: CGFloat(ofSize))
            }
            .startWith(LabelViewControllerConstants.fontCode)
        
        let alignmentCode = alignmentCellDidSelected
            .map { $0.code }
            .startWith(LabelViewControllerConstants.alignmentCode)
        
        let numberOfLinesCode = numberOfLinesCellDidChangedLineStepper
            .map { "\($0)" }
            .startWith(LabelViewControllerConstants.numberOfLinesCode)
        
        codeCellCodeLabelText = Observable
            .combineLatest(textCode, textColorCode, backgroundColorCode, fontCode, alignmentCode, numberOfLinesCode, resultSelector: labelModel.codeLabelText)
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func labelSettingListDataSource() -> RxTableViewSectionedReloadDataSource<LabelSettingListSectionModel> {
        let dataSource = RxTableViewSectionedReloadDataSource<LabelSettingListSectionModel> { dataSource, tableView, indexPath, sectionModelItem in
            LabelModel.makeCell(
                dataSource[indexPath.section].sectionHeader,
                self,
                tableView,
                indexPath,
                sectionModelItem
            )
        } // RxTableViewSectionedReloadDataSource
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            dataSource.sectionModels[index].sectionHeader.rawValue
        }
        
        return dataSource
        
    } // func labelSettingListDataSource    
}
