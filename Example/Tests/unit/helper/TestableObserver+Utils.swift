//
//  TestableObserver+Utils.swift
//  AbitData
//
//  Created by Eli Kohen on 23/06/2017.
//  Copyright © 2017 Metropolis Lab. All rights reserved.
//

import RxTest

extension TestableObserver {
    
    var elements: [Element] {
        return events.flatMap { $0.value.element }
    }
    
    var value: Element? {
        return elements.last
    }
}

