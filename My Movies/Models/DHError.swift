//
//  DHError.swift
//  Trader
//
//  Created by Keerthana on 01/03/18.
//  Copyright © 2018 QBurst. All rights reserved.
//

import Foundation
import ObjectMapper

/// Error model
class DHError: Mappable {

    /// Gets or sets the error code
    var code: String?

    /// Gets or sets the error message
    var message: String?

    /// Gets or sets the error code
    var intCode: Int?

    /// Required initializer
    ///
    /// - Parameter map: Map data
    required init?(map: Map) {
    }

    /// Mapper function to map values
    ///
    /// - Parameter map: Map data
    func mapping(map: Map) {
        intCode <- map["code"]
        if intCode == nil {
            code <- map["code"]
        } else {
            code = String(describing: intCode!)
        }
        message <- map["message"]
    }
}
