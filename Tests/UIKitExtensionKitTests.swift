//
//  UIKitExtensionKitTests.swift
//  ZZExtensionKit
//
//  Created by zzangzio on 2018. 12. 2..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import XCTest
@testable import ZZExtensionKit

class CGSizeTests: XCTestCase {

    func testSizeRect() {
        let size = CGSize(width: 100, height: 200)
        let expectedRect = CGRect(origin: .zero, size: size)

        XCTAssertEqual(size.rect, expectedRect)
    }

    func testSizeArea() {
        let size = CGSize(width: 100, height: 200)
        let expectedArea = CGFloat(100 * 200)

        XCTAssertEqual(size.area, expectedArea)
    }

    func testResizedConstrainedPixel() {
        let size = CGSize(width:100, height: 200)

        XCTAssertLessThanOrEqual(size.resized(constrainedPixel: 20000, scale: 1).area, 20000)
        XCTAssertLessThanOrEqual(size.resized(constrainedPixel: 10000, scale: 1).area, 10000)
        XCTAssertLessThanOrEqual(size.resized(constrainedPixel: 5000, scale: 1).area, 5000)
    }

    func testResizedToScale() {
        let size = CGSize(width:100, height: 200)

        XCTAssertEqual(size.resized(toScale: 0.5), CGSize(width: 50, height: 100))
        XCTAssertEqual(size.resized(toScale: 2), CGSize(width: 200, height: 400))
        XCTAssertEqual(size.resized(toScale: 3), CGSize(width: 300, height: 600))
    }

    func textResizedAspectFit() {
        let size = CGSize(width:100, height: 200)

        XCTAssertEqual(size.resizedAspectFit(fitSize: CGSize(width: 100, height: 100)),
                       CGSize(width: 50, height: 100))
        XCTAssertEqual(size.resizedAspectFit(fitSize: CGSize(width: 200, height: 200)),
                       CGSize(width: 100, height: 200))
        XCTAssertEqual(size.resizedAspectFit(fitSize: CGSize(width: 100, height: 50)),
                       CGSize(width: 25, height: 50))
    }
}

class CGRectTests: XCTestCase {
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
