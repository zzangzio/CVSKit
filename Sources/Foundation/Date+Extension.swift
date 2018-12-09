//
//  Date+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 2018. 12. 9..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit

public enum DateUnit {
    case day, month, year

    fileprivate var componentsSet: Set<Calendar.Component> {
        switch self {
        case .day:
            return [.year, .month, .day]
        case .month:
            return [.year, .month]
        case .year:
            return [.year]
        }
    }

    fileprivate var addingComponents: DateComponents {
        switch self {
        case .day:
            return DateComponents(day: 1)
        case .month:
            return DateComponents(month: 1)
        case .year:
            return DateComponents(year: 1)
        }
    }
}

extension Date {
    public func startOfUnit(_ unit: DateUnit) -> Date {
        let startDay = Calendar.current.startOfDay(for: self)
        let dateComponents = Calendar.current.dateComponents(unit.componentsSet, from: startDay)
        return Calendar.current.date(from: dateComponents)!
    }

    public func nextStartOfUnit(_ unit: DateUnit) -> Date {
        return Calendar.current.date(byAdding: unit.addingComponents, to: startOfUnit(unit))!
    }
}
