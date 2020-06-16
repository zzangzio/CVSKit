//
//  ChameleonView.swift
//  CVSKit
//
//  Created by zzangzio on 2018. 12. 15..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit

open class ChameleonView: UIView {
    open var minFeel: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }

    open var maxFeel: CGFloat = 1 {
        didSet { setNeedsDisplay() }
    }

    open var feel: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }

    private var colorComponentAndLocations = [((CGFloat, CGFloat, CGFloat, CGFloat), CGFloat)]()

    // MARK: -

    open func set(colorAndLocations: [(UIColor, CGFloat)]) {
        colorComponentAndLocations = colorAndLocations.map
        { (colorAndLocation) -> ((CGFloat, CGFloat, CGFloat, CGFloat), CGFloat) in
            var colorComponent = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
            colorAndLocation.0.getRed(
                &colorComponent.0,
                green: &colorComponent.1,
                blue: &colorComponent.2,
                alpha: &colorComponent.3
            )
            return (colorComponent, colorAndLocation.1)
        }

        setNeedsDisplay()
    }

    open func set(argbAndLocations: [(UInt32, CGFloat)]) {
        colorComponentAndLocations = argbAndLocations.map
        { (argbAndLocations) -> ((CGFloat, CGFloat, CGFloat, CGFloat), CGFloat) in
            let argb = argbAndLocations.0

            let a = CGFloat((argb & 0xFF000000) >> 24) / 255
            let r = CGFloat((argb & 0x00FF0000) >> 16) / 255
            let g = CGFloat((argb & 0x0000FF00) >> 8) / 255
            let b = CGFloat((argb & 0x000000FF) >> 0) / 255
            return ((r, g, b, a), argbAndLocations.1)
        }

        setNeedsDisplay()
    }

    override open func draw(_ rect: CGRect) {
        super.draw(rect)

        if colorComponentAndLocations.isEmpty {
            backgroundColor = .clear
            return
        } else if colorComponentAndLocations.count == 1 {
            let colorComponent = colorComponentAndLocations[0].0
            backgroundColor = UIColor(
                red: colorComponent.0,
                green: colorComponent.1,
                blue: colorComponent.2,
                alpha: colorComponent.3
            )
            return
        }

        let leftIndex: Int = {
            var leftIndex = 0
            colorComponentAndLocations.forEachStop { each, index, stop in
                if each.1 >= feel {
                    leftIndex = index - 1
                    stop = true
                }
            }
            return leftIndex.boundary(minimum: 0, maximum: colorComponentAndLocations.count - 2)
        }()

        let rightIndex = leftIndex + 1

        let (leftComponent, leftLocation) = colorComponentAndLocations[leftIndex]
        let (rightComponent, rightLocation) = colorComponentAndLocations[rightIndex]

        let maxValue = rightLocation - leftLocation
        let rWeight = (feel - leftLocation) / maxValue
        let lWeight = 1 - rWeight

        let r = (leftComponent.0 * lWeight + rightComponent.0 * rWeight)
        let g = (leftComponent.1 * lWeight + rightComponent.1 * rWeight)
        let b = (leftComponent.2 * lWeight + rightComponent.2 * rWeight)
        let a = leftComponent.3 * lWeight + rightComponent.3 * rWeight

        let rgba = [r, g, b, a]
        UIGraphicsGetCurrentContext().map { context in
            context.setFillColor(rgba)
            context.fill(rect)
        }
    }
}
