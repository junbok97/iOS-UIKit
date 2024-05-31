//
//  UILabelSettingListViewReactor.swift
//  UILabel
//
//  Created by 이준복 on 5/29/24.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa

import DesignKit

public final class UILabelSettingListViewReactor: Reactor {
    
    // MARK: - Init
    public init() {}
    
    // MARK: - Property
    public let initialState = State()
    
    // MARK: - Action
    public enum Action {
        case textChanged(String)
        case textAlignmentChanged(DKTextAlignmentType)
        case colorChanged(DKColor)
        case fontTypeChanged(DKFontType)
        case fontSizeChanged(Float)
        case numberOfLinesChanged(Double)
    }
    
    // MARK: - Mutation
    public enum Mutation {
        case setText(String)
        case setTextColor(UIColor)
        case setBackgroundColor(UIColor)
        case setFontType(DKFontType)
        case setFontSize(CGFloat)
        case setTextAlignment(DKTextAlignmentType)
        case setNumberOfLines(Int)
        case updateCode
    }
    
    // MARK: - State
    public struct State {
        
        var code: String {
        """
        private let label: UIlabel = {
            let label = UILabel()
            
            label.text = \"\(text)\"
            label.textAlignment = \(textAlignment.code)
            label.textColor = \(textColor.cgColor.getRGBCode)
            label.backgroundColor = \(backgroudColor.cgColor.getRGBCode)
            label.font = \(fontType.code(ofSize: CGFloat(fontSize)))
            label.numberOfLines = \(numberOfLines)
            return label
        }()
        """
        }
        
        var text: String = TargetLabel.text
        var textColor: UIColor = TargetLabel.textColor
        var backgroudColor: UIColor = TargetLabel.backgroundColor
        var fontType: DKFontType = TargetLabel.fontType
        var fontSize: CGFloat = TargetLabel.fontSize
        var textAlignment: DKTextAlignmentType = TargetLabel.textAlignment
        var numberOfLines: Int = TargetLabel.numberOfLines
    }
    
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case var .textChanged(text):
            text =  text.isEmpty ? TargetLabel.text : text
            return Observable.concat([
                Observable.just(Mutation.setText(text))
            ])
            
        case let .textAlignmentChanged(alignment):
            return Observable.just(Mutation.setTextAlignment(alignment))
            
        case let .colorChanged(color):
            switch color.colorType {
                
            case .text:
                return Observable.just(Mutation.setTextColor(color.color))
                
            case .background:
                return Observable.just(Mutation.setBackgroundColor(color.color))
                
            default:
                return Observable.empty()
            }
            
        case let .fontTypeChanged(fontType):
            return Observable.just(Mutation.setFontType(fontType))
            
        case let .fontSizeChanged(fontSize):
            return Observable.just(Mutation.setFontSize(CGFloat(fontSize)))
            
        case let .numberOfLinesChanged(numberOfLines):
            return Observable.just(Mutation.setNumberOfLines(Int(numberOfLines)))
        }
        
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .updateCode:
            return state
            
        case let .setText(text):
            var newState = state
            newState.text = text
            return newState
            
        case let .setTextColor(textColor):
            var newState = state
            newState.textColor = textColor
            return newState
            
        case let .setBackgroundColor(backgroundColor):
            var newState = state
            newState.backgroudColor = backgroundColor
            return newState
            
        case let .setFontType(fontType):
            var newState = state
            newState.fontType = fontType
            return newState
            
        case let .setFontSize(fontSize):
            var newState = state
            newState.fontSize = CGFloat(fontSize)
            return newState
            
        case let .setTextAlignment(textAlignment):
            var newState = state
            newState.textAlignment = textAlignment
            return newState
            
        case let .setNumberOfLines(numberOfLines):
            var newState = state
            newState.numberOfLines = numberOfLines
            return newState
        }
        
    }
    
    
    
}
