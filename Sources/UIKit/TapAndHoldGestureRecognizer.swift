//
//  TapAndHoldGestureRecognizer.swift
//  CVSKit
//
//  Created by zzangzio on 2020/06/15.
//  Copyright © 2020 zzangzio. All rights reserved.
//

import UIKit

public class TapAndHoldGestureRecognizer: UIGestureRecognizer {
    private enum TapAndHoldState {
        case ready
        case began
        case waitingHold
        case hold
    }

    private let delayPerformer = DelayPerformer(defaultDelay: 0.3)
    private var tapAndHoldState: TapAndHoldState = .ready
    public private(set) var holdPoint: CGPoint?

    public override func reset() {
        super.reset()
        tapAndHoldState = .ready
        holdPoint = nil
    }

    public var slideOffset: CGPoint? {
        guard let holdPoint = holdPoint else { return nil }
        let location = self.location(in: view)
        return CGPoint(x: location.x - holdPoint.x, y: location.y - holdPoint.y)
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        guard touches.count == 1 else {
            state = .failed
            return
        }

        switch tapAndHoldState {
        case .ready:
            tapAndHoldState = .began
        case .waitingHold:
            delayPerformer.perform {[weak self] in
                guard let self = self else { return }
                self.holdPoint = self.location(in: self.view)
                self.tapAndHoldState = .hold
                self.state = .changed
            }
        default:
            state = .failed
        }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)

        switch tapAndHoldState {
        case .began:
            tapAndHoldState = .waitingHold
            delayPerformer.perform { [weak self] in
                guard let self = self else { return }
                self.state = .failed
            }
        case .hold:
            state = .ended
        default:
            delayPerformer.cancel()
            state = .failed
        }
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        guard tapAndHoldState == .hold else { return }
        state = .changed
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        delayPerformer.cancel()
    }
}
