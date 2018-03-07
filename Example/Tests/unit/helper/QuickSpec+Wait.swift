//
//  QuickSpec+Wait.swift
//  AbitData
//
//  Created by Eli Kohen on 26/06/2017.
//  Copyright © 2017 Metropolis Lab. All rights reserved.
//

import Quick

extension QuickSpec {
    func waitFor(timeout: TimeInterval, completion: (() -> Void)? = nil) {
        
        let expectation = self.expectation(description: "Wait for")
        let when = DispatchTime.now() + timeout
        DispatchQueue.global(qos: .background).asyncAfter(deadline: when) {
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: timeout + 0.1) { _ in
            completion?()
        }
    }
}
