//
//  CGSize.swift
//  CVSKit
//
//  Created by zzangzio on 25/11/2018.
//

import UIKit

extension CGSize {
    public var rect: CGRect {
        return CGRect(origin: .zero, size: self)
    }
    
    public var area: CGFloat {
        return width * height
    }
    
    public func resized(constrainedPixel: Int,
                        scale: CGFloat = UIScreen.main.scale) -> CGSize {
        let pixel = (width * scale) * (height * scale)
        guard pixel > CGFloat(constrainedPixel) else { return self }
        let toScale = CGFloat(constrainedPixel) / pixel
        return CGSize(width: (width * sqrt(toScale)).rounded(.down),
                      height: (height * sqrt(toScale)).rounded(.down))
    }
    
    public func resized(toScale: CGFloat) -> CGSize {
        return CGSize(width: width * toScale, height: height * toScale)
    }
    
    public func resizedAspectFit(fitSize: CGSize) -> CGSize {
        let ratio = min(fitSize.width / width, fitSize.height / height)
        return self.resized(toScale: ratio)
    }
}
