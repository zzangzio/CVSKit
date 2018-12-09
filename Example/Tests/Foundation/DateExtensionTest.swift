//
//  DateExtensionTest.swift
//  CVSKitTests
//
//  Created by zzangzio on 2018. 12. 9..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import XCTest
@testable import CVSKit

class DateExtensionTest: XCTestCase {
    func testStartOfDay() {
        let calendar = Calendar.current
        guard let testDate = calendar.date(from: DateComponents(year: 2018, month: 12, day: 9, hour: 8)) else {
            XCTFail("testStartOfDay")
            return
        }
        let startDate = testDate.startOfUnit(.day)

        let components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: startDate
        )
        XCTAssertEqual(components.year, 2018, "year: \(components.year ?? 0)")
        XCTAssertEqual(components.month, 12, "month: \(components.month ?? 0)")
        XCTAssertEqual(components.day, 9, "day: \(components.day ?? 0)")
        XCTAssertEqual(components.hour, 0, "hour: \(components.hour ?? 0)")
        XCTAssertEqual(components.minute, 0, "minute: \(components.minute ?? 0)")
        XCTAssertEqual(components.second, 0, "second: \(components.second ?? 0)")
    }

    func testNextStartOfDay() {
        let calendar = Calendar.current
        guard let testDate = calendar.date(from: DateComponents(year: 2018, month: 12, day: 9, hour: 8)) else {
            XCTFail("testStartOfDay")
            return
        }
        let startDate = testDate.nextStartOfUnit(.day)

        let components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: startDate
        )
        XCTAssertEqual(components.year, 2018, "year: \(components.year ?? 0)")
        XCTAssertEqual(components.month, 12, "month: \(components.month ?? 0)")
        XCTAssertEqual(components.day, 10, "day: \(components.day ?? 0)")
        XCTAssertEqual(components.hour, 0, "hour: \(components.hour ?? 0)")
        XCTAssertEqual(components.minute, 0, "minute: \(components.minute ?? 0)")
        XCTAssertEqual(components.second, 0, "second: \(components.second ?? 0)")
    }

    func testStartOfMonth() {
        let calendar = Calendar.current
        guard let testDate = calendar.date(from: DateComponents(year: 2018, month: 12, day: 9, hour: 8)) else {
            XCTFail("testStartOfDay")
            return
        }
        let startDate = testDate.startOfUnit(.month)

        let components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: startDate
        )

        XCTAssertEqual(components.year, 2018, "year: \(components.year ?? 0)")
        XCTAssertEqual(components.month, 12, "month: \(components.month ?? 0)")
        XCTAssertEqual(components.day, 1, "day: \(components.day ?? 0)")
        XCTAssertEqual(components.hour, 0, "hour: \(components.hour ?? 0)")
        XCTAssertEqual(components.minute, 0, "minute: \(components.minute ?? 0)")
        XCTAssertEqual(components.second, 0, "second: \(components.second ?? 0)")
    }

    func testNextStartOfMonth() {
        let calendar = Calendar.current
        guard let testDate = calendar.date(from: DateComponents(year: 2018, month: 12, day: 9, hour: 8)) else {
            XCTFail("testStartOfDay")
            return
        }
        let startDate = testDate.nextStartOfUnit(.month)

        let components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: startDate
        )
        XCTAssertEqual(components.year, 2019, "year: \(components.year ?? 0)")
        XCTAssertEqual(components.month, 1, "month: \(components.month ?? 0)")
        XCTAssertEqual(components.day, 1, "day: \(components.day ?? 0)")
        XCTAssertEqual(components.hour, 0, "hour: \(components.hour ?? 0)")
        XCTAssertEqual(components.minute, 0, "minute: \(components.minute ?? 0)")
        XCTAssertEqual(components.second, 0, "second: \(components.second ?? 0)")
    }

    func testStartOfYear() {
        let calendar = Calendar.current
        guard let testDate = calendar.date(from: DateComponents(year: 2018, month: 12, day: 9, hour: 8)) else {
            XCTFail("testStartOfDay")
            return
        }
        let startDate = testDate.startOfUnit(.year)

        let components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: startDate
        )

        XCTAssertEqual(components.year, 2018, "year: \(components.year ?? 0)")
        XCTAssertEqual(components.month, 1, "month: \(components.month ?? 0)")
        XCTAssertEqual(components.day, 1, "day: \(components.day ?? 0)")
        XCTAssertEqual(components.hour, 0, "hour: \(components.hour ?? 0)")
        XCTAssertEqual(components.minute, 0, "minute: \(components.minute ?? 0)")
        XCTAssertEqual(components.second, 0, "second: \(components.second ?? 0)")
    }

    func testNextStartOfYear() {
        let calendar = Calendar.current
        guard let testDate = calendar.date(from: DateComponents(year: 2018, month: 12, day: 9, hour: 8)) else {
            XCTFail("testStartOfDay")
            return
        }
        let startDate = testDate.nextStartOfUnit(.year)

        let components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: startDate
        )
        XCTAssertEqual(components.year, 2019, "year: \(components.year ?? 0)")
        XCTAssertEqual(components.month, 1, "month: \(components.month ?? 0)")
        XCTAssertEqual(components.day, 1, "day: \(components.day ?? 0)")
        XCTAssertEqual(components.hour, 0, "hour: \(components.hour ?? 0)")
        XCTAssertEqual(components.minute, 0, "minute: \(components.minute ?? 0)")
        XCTAssertEqual(components.second, 0, "second: \(components.second ?? 0)")
    }
}
