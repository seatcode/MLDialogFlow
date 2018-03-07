//
//  Event+Util.swift
//  AbitData
//
//  Created by Eli Kohen on 11/07/2017.
//  Copyright © 2017 Metropolis Lab. All rights reserved.
//

import RxSwift

extension Event {
    var isCompleted: Bool {
        switch self {
        case .completed:
            return true
        default:
            return false
        }
    }
    
    var isError: Bool {
        switch self {
        case .error:
            return true
        default:
            return false
        }
    }
}
