//
//  CircularProgressView.swift
//  CVSKit
//
//  Created by zzangzio on 2018. 12. 15..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit

private class CircularProgressLayer: CALayer {
    @NSManaged var progress: CGFloat
    var maxProgress: CGFloat = 1
    var zeroDimension: CGFloat = 0.01

    var progressWidth: CGFloat = 4 {
        didSet { setNeedsDisplay() }
    }

    var progressColor: UIColor = .black {
        didSet { setNeedsDisplay() }
    }

    var trackColor: UIColor = .lightGray {
        didSet { setNeedsDisplay() }
    }

    var trackWidth: CGFloat = 4 {
        didSet { setNeedsDisplay() }
    }

    var clockWise: Bool = true {
        didSet { setNeedsDisplay() }
    }

    var startAngle: CGFloat = (-CGFloat.pi / 2) {
        didSet { setNeedsDisplay() }
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init() {
        super.init()
    }

    override init(layer: Any) {
        super.init(layer: layer)
        if let progressLayer = layer as? CircularProgressLayer {
            progress = progressLayer.progress
            maxProgress = progressLayer.maxProgress
            zeroDimension = progressLayer.zeroDimension
            progressColor = progressLayer.progressColor
            progressWidth = progressLayer.progressWidth
            trackColor = progressLayer.trackColor
            trackWidth = progressLayer.trackWidth
            clockWise = progressLayer.clockWise
            startAngle = progressLayer.startAngle
        }
    }

    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)

        UIGraphicsPushContext(ctx)
        ctx.setShouldAntialias(true)

        let trackBounds = bounds
        let center = CGPoint(x: trackBounds.size.width / 2, y: trackBounds.size.height / 2)

        // draw progress
        let trackRadius = (trackBounds.size.width / 2) - (trackWidth * 0.5)

        trackColor.setStroke()
        let trackPath = UIBezierPath(
            arcCenter: center,
            radius: trackRadius,
            startAngle: 0,
            endAngle: CGFloat.pi * 2,
            clockwise: true
        )

        trackPath.lineWidth = trackWidth
        trackPath.stroke()

        let radius = (trackBounds.size.width / 2) - (progressWidth * 0.5) - (trackWidth - progressWidth) / 2
        let endAngle = (progress / maxProgress * 2 * CGFloat.pi) + startAngle

        progressColor.setStroke()

        let progressPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: clockWise
        )
        progressPath.lineCapStyle = .round
        progressPath.lineWidth = progressWidth
        progressPath.stroke()

        UIGraphicsPopContext()
    }

    override class func needsDisplay(forKey key: String) -> Bool {
        guard key == #keyPath(progress) else {
            return super.needsDisplay(forKey: key)
        }
        return true
    }
}

open class CircularProgressView: UIView {
    override open class var layerClass: AnyClass {
        return CircularProgressLayer.self
    }

    private var myLayer: CircularProgressLayer {
        return layer as! CircularProgressLayer
    }

    open var progress: CGFloat = 0 {
        didSet {
            myLayer.progress = max(maxProgress * myLayer.zeroDimension, progress)
        }
    }

    open var maxProgress: CGFloat {
        set {
            myLayer.maxProgress = newValue
            myLayer.progress = max(newValue * myLayer.zeroDimension, progress)
        }
        get { return myLayer.maxProgress }
    }

    open var zeroDimension: CGFloat {
        set {
            myLayer.zeroDimension = newValue
            myLayer.progress = max(maxProgress * newValue, progress)
        }
        get { return myLayer.zeroDimension }
    }

    open var progressWidth: CGFloat {
        set { myLayer.progressWidth = newValue }
        get { return myLayer.progressWidth }
    }

    open var progressColor: UIColor {
        set { myLayer.progressColor = newValue }
        get { return myLayer.progressColor }
    }

    open var trackColor: UIColor {
        set { myLayer.trackColor = newValue }
        get { return myLayer.trackColor }
    }

    open var trackWidth: CGFloat {
        set { myLayer.trackWidth = newValue }
        get { return myLayer.trackWidth }
    }

    open var clockWise: Bool {
        set { myLayer.clockWise = newValue }
        get { return myLayer.clockWise }
    }

    open var startAngle: CGFloat {
        set { myLayer.startAngle = newValue }
        get { return myLayer.startAngle }
    }

    public required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override public init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .redraw
        backgroundColor = UIColor.clear
        myLayer.progress = max(maxProgress * myLayer.zeroDimension, progress)
    }

    override open func action(for layer: CALayer, forKey event: String) -> CAAction? {
        let keyPath = #keyPath(CircularProgressLayer.progress)
        if event == keyPath,
            let action = super.action(for: layer, forKey: #keyPath(backgroundColor)) as? CAAnimation {
            let animation = CABasicAnimation(keyPath: keyPath)
            animation.fromValue = myLayer.progress
            animation.toValue = progress
            animation.beginTime = action.beginTime
            animation.duration = action.duration
            animation.speed = action.speed
            animation.timeOffset = action.timeOffset
            animation.repeatCount = action.repeatCount
            animation.repeatDuration = action.repeatDuration
            animation.autoreverses = action.autoreverses
            animation.fillMode = action.fillMode
            animation.timingFunction = action.timingFunction
            animation.delegate = action.delegate
            myLayer.add(animation, forKey: keyPath)
        }

        return super.action(for: layer, forKey: event)
    }
}
