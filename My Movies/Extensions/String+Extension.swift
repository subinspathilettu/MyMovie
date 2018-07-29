//
//  String+Extension.swift
//  My Movies
//
//  Created by Subins P Jose on 29/07/18.
//  Copyright © 2018 Subins P Jose. All rights reserved.
//

import Foundation


extension String {
    /// Generate localized string.
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
