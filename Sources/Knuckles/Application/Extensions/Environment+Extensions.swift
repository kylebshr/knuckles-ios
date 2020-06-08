//
//  Environment+Extensions.swift
//  Knuckles
//
//  Created by Kyle Bashour on 6/8/20.
//

import LinkKit

extension Environment {
    var plaidEnvironment: PLKEnvironment {
        switch self {
        case .production:
            return .development
        case .local:
            return .sandbox
        }
    }
}
