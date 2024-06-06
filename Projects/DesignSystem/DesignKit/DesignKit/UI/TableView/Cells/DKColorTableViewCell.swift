//
//  DKColorTableViewCell.swift
//  DesignKit
//
//  Created by 이준복 on 5/9/24.
//

import UIKit

import PinLayout
import FlexLayout
import RxSwift
import RxCocoa
import Then

import CoreKit

public protocol DKColorTableViewCellListener: AnyObject {
    var colorSelectedObserver: AnyObserver<DKColor> { get }
}

public final class DKColorTableViewCell: DKBaseTableViewCell {
    
    // MARK: - Properties
    private var disposeBag = DisposeBag()
    private var colorType: DKColorType?
    
    // MARK: - UI
    private let titleLabel = UILabel().then { label in
        label.font = DKDefaultConstants.font
        label.textColor = .label
    }
    private let colorWell = UIColorWell()
    
    // MARK: - View Life Cycles
    public override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        layout()
        return contentView.frame.size
    }
    
    // MARK: - View Methods
    private func layout() {
        contentView.flex.layout(mode: .adjustHeight)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        contentView.flex.padding(DKDefaultConstants.padding).define { flex in
            flex.addItem().direction(.row).define { flex in
                flex.addItem(titleLabel).grow(1)
                flex.addItem(colorWell)
            }
        }
    }
    
    override func reset() {
        super.reset()
        
        disposeBag = DisposeBag()
        titleLabel.text = Constants.TitleLabel.defaultText
    }
    
    // MARK: - Bind
    public func bind(_ listener: DKColorTableViewCellListener) {
        colorWell.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .compactMap { (object, _) -> DKColor? in
                guard let color = object.colorWell.selectedColor,
                      let colorType = object.colorType else { return nil }
                return DKColor(color: color, colorType: colorType)
            }
            .distinctUntilChanged()
            .bind(to: listener.colorSelectedObserver)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Logic
    public func setupColorType(_ colorType: DKColorType) {
        titleLabel.text = colorType.title
        self.colorType = colorType
    }
    
}

// MARK: - Constants
private extension DKColorTableViewCell {
    
    enum Constants {
        enum TitleLabel {
            static var defaultText: String { "default Color" }
        }
    }
}
