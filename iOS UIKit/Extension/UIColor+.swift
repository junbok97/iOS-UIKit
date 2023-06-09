//
//  UIColor+.swift
//  iOS UIKit
//
//  Created by 이준복 on 2023/05/20.
//

import UIKit

extension CGColor {
    var getRGBCode: String {
        guard let components = self.components, 2 <= components.count else { return "nil" }
        
        if components.count == 2 {
            let white = components[0]
            let alpha = components[1]
            
            return
            """
            UIColor(
                white: \(white),
                alpha: \(alpha)
            )
            """
        }
        
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        let alpha = components[3]
        
        return
        """
        UIColor(
            red: \(red),
            green: \(green),
            blue: \(blue),
            alpha: \(alpha)
        )
        """
    }
}
