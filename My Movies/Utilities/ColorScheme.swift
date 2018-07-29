//
//  ColorScheme.swift
//  Trader
//
//  Created by Subins on 08/01/18.
//  Copyright © 2018 QBurst. All rights reserved.
//

import UIKit

/// Enumeration to define the colours
///
/// - theme: theme color
/// - primary: primary color
/// - secondary: secondary color
/// - border: border color
/// - shadow: shadow color
/// - tintColor: tint color
/// - title: title color
/// - facebook: facebook background color
/// - google: google background color
/// - chipViewBorder: chipview border color
/// - subTitle: subtitle color
/// - buttonTitle: button title color
/// - affirmation: affirmation color
/// - negation: negation color
/// - custom: custom color
enum Color {
    case theme
    case primary
    case secondary
    case border
    case shadow
    case tintColor
    case title
    case facebook
    case google
    case chipViewBorder
    case subTitle
    case buttonTitle
    case affirmation
    case negation
    case teritiary
    case custom(hexString: String, alpha: Double)

    /// To get the color with required alpha component
    ///
    /// - Parameter alpha: alpha value
    /// - Returns: Color with required alpha
    func withAlpha(_ alpha: Double) -> UIColor {
        return self.value.withAlphaComponent(CGFloat(alpha))
    }
}

// MARK: - Extension to return pre-defined color
extension Color {

    /// returns color value based on enum
    var value: UIColor {
        var instanceColor = UIColor.clear
        switch self {
        case .theme: instanceColor = UIColor(hexString: "#fafafa")
        case .border: instanceColor = UIColor(hexString: "#d6d6d6")
        case .primary: instanceColor = UIColor(hexString: "#4ec3ff")
        case .secondary: instanceColor = UIColor(hexString: "#fea06f") //Light salmon
        case .facebook: instanceColor = UIColor(hexString: "#3b5998")
        case .google: instanceColor = UIColor(hexString: "#d34836")
        case .tintColor: instanceColor = UIColor(hexString: "#3b3b3b")
        case .shadow: instanceColor = UIColor(hexString: "#cccccc")
        case .subTitle: instanceColor = UIColor(hexString: "#444444").withAlphaComponent(0.54)
        case .affirmation: instanceColor = UIColor(hexString: "#00ff66")
        case .negation: instanceColor = UIColor(hexString: "#e53935")
        case .custom(let hexValue, let opacity):
            instanceColor = UIColor(hexString: hexValue).withAlphaComponent(CGFloat(opacity))
        case .title: instanceColor = UIColor(hexString: "#444444").withAlphaComponent(0.87)
        case .buttonTitle: instanceColor = UIColor(hexString: "ffffff")
        case .chipViewBorder: instanceColor = UIColor(hexString: "9aa6ab")
        case .teritiary: instanceColor = UIColor(hexString: "2892cb")
        }
        return instanceColor
    }
}
