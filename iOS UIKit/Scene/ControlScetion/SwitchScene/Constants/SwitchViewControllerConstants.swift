//
//  SwitchViewControllerConstants.swift
//  iOS UIKit
//
//  Created by 이준복 on 2023/05/22.
//

import Foundation

protocol SwitchViewControllerConstantsProtocol: DefaultListViewControllerConstantsProtocol {}

extension SwitchViewControllerConstantsProtocol {
    static var title: String { "Switch" }
    static var documentURLString: String { "https://developer.apple.com/documentation/uikit/uiswitch" }
    
    static var containerViewHeight: CGFloat { 100.0 }
    
    static var defaultSwitchCode: String {
    """
    lazy var toggle: UISwitch = {
        let toggle = UISwitch()
        
        toggle.isOn = true
        toggle.onTintColor = .systemGreen
        toggle.thumbTintColor = .white
        toggle.backgroundColor = .systemBackground
        
        return toggle
    }()
    """
    }
}

struct SwitchViewControllerConstants: SwitchViewControllerConstantsProtocol {}
