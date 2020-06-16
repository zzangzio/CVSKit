//
//  CGRectExtensionTest.swift
//  CVSKitTests
//
//  Created by zzangzio on 2018. 12. 9..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

@testable import CVSKit
import XCTest

class CGRectExtensionTest: XCTestCase {
    func testIntersectionRatio() {
        let r1 = CGRect(x: 0, y: 0, width: 100, height: 100)
        var r2 = CGRect(x: 50, y: 0, width: 100, height: 100)

        XCTAssertEqual(r1.intersectionRatio(r2), 0.5)

        r2 = CGRect(x: 50, y: 50, width: 100, height: 100)
        XCTAssertEqual(r1.intersectionRatio(r2), 0.25)

        r2 = CGRect(x: 0, y: 50, width: 100, height: 50)
        XCTAssertEqual(r1.intersectionRatio(r2), 0.5)
        XCTAssertEqual(r2.intersectionRatio(r1), 1)
    }
}
