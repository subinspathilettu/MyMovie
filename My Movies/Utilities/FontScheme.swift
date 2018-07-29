//
//  FontScheme.swift
//  Trader
//
//  Created by Keerthana on 29/01/18.
//  Copyright © 2018 QBurst. All rights reserved.
//

import Foundation
import UIKit

/// Enumeration to define required fonts
///
/// - regular17pt: regular font with size 17pt
/// - bold17pt: bold font with size 17pt
/// - medium17pt: medium font with size 17pt
/// - medium15pt: medium font with size 15pt
/// - regular: regular font with size as parameter value
/// - medium: medium font with size as parameter value
/// - bold: bold font with size as parameter value
enum Font {
    case regular17pt
    case bold17pt
    case medium17pt
    case medium15pt
    case regular(size: CGFloat)
    case medium(size: CGFloat)
    case bold(size: CGFloat)
    case light(size: CGFloat)
}

// MARK: - Extension to define fonts related to the application
extension Font {
    /// Return font based on the enum
    var value: UIFont {
        var instanceFont = UIFont(name: "Roboto-Medium", size: 17)
        switch self {
        case .regular17pt:
            instanceFont = UIFont(name: "Roboto-Regular", size: 17)
        case .bold17pt:
            instanceFont = UIFont(name: "Roboto-Bold", size: 17)
        case .medium17pt:
            instanceFont = UIFont(name: "Roboto-Medium", size: 17)
        case .medium15pt:
            instanceFont = UIFont(name: "Roboto-Medium", size: 15)
        case .regular(let size):
            instanceFont = UIFont(name: "Roboto-Regular", size: size)
        case .medium(let size):
            instanceFont = UIFont(name: "Roboto-Medium", size: size)
        case .bold(let size):
            instanceFont = UIFont(name: "Roboto-Bold", size: size)
        case .light(let size):
            instanceFont = UIFont(name: "Roboto-Light", size: size)
        }
        return instanceFont!
    }
}
