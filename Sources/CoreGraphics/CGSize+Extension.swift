//
//  CGSize.swift
//  CVSKit
//
//  Created by zzangzio on 25/11/2018.
//

import CoreGraphics

public extension CGSize {
    var rect: CGRect {
        return CGRect(origin: .zero, size: self)
    }

    var area: CGFloat {
        return width * height
    }

    func resized(
        constrainedPixel: Int,
        scale: CGFloat = UIScreen.main.scale
    ) -> CGSize {
        let pixel = (width * scale) * (height * scale)
        guard pixel > CGFloat(constrainedPixel) else { return self }
        let toScale = CGFloat(constrainedPixel) / pixel
        return CGSize(
            width: (width * sqrt(toScale)).rounded(.down),
            height: (height * sqrt(toScale)).rounded(.down)
        )
    }

    func resized(toScale: CGFloat) -> CGSize {
        return CGSize(width: width * toScale, height: height * toScale)
    }

    func resizedAspectFit(fitSize: CGSize) -> CGSize {
        let ratio = min(fitSize.width / width, fitSize.height / height)
        return resized(toScale: ratio)
    }

    func rounded(_ rule: FloatingPointRoundingRule) -> CGSize {
        CGSize(width: width.rounded(rule), height: height.rounded(rule))
    }
}
