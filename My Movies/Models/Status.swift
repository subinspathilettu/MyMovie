//
//  Status.swift
//  Trader
//
//  Created by Keerthana on 28/02/18.
//  Copyright © 2018 QBurst. All rights reserved.
//

import Foundation
import ObjectMapper

/// Status model
class Status: Response {

    /// Gets or sets the status code
    var code: String?

    /// Gets or sets the status name
    var name: String?

    /// Mapper function to map values
    ///
    /// - Parameter map: Map data
    override func mapping(map: Map) {
        super.mapping(map: map)
        code <- map["code"]
        name <- map["name"]
    }
}
