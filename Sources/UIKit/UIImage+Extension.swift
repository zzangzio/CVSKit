//
//  UIImage+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 17/11/2018.
//

import UIKit

extension UIImage {
    public static func create(size: CGSize,
                              opaque: Bool = false,
                              scale: CGFloat = 0,
                              draw: (CGContext) -> Void) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let context = UIGraphicsGetCurrentContext()!
        draw(context)
        let createdImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return createdImage
    }
    
    public convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let colorImage = UIImage.create(size: size) { (context) in
            context.setFillColor(color.cgColor)
            context.fill(size.rect)
        }
        self.init(cgImage: colorImage.cgImage!)
    }
    
    public var stretchable: UIImage {
        return stretchableImage(withLeftCapWidth: Int(size.width / 2), topCapHeight: Int(size.height / 2))
    }
    
    public static func createAsync(withData data: Data, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.userInitiated.async(execute: { UIImage(data: data) }, afterInMain: { completion($0) })
    }
    
    public func with(alpha: CGFloat) -> UIImage {
        return UIImage.create(size: size, scale: scale) { (context) in
            draw(in: size.rect, blendMode: .normal, alpha: alpha)
        }
    }
    
    public func createAsync(withAlpha alpha: CGFloat, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.userInitiated.async(execute: { self.with(alpha: alpha) },
                                          afterInMain: { completion($0) })
    }
    
    public func with(tintColor: UIColor) -> UIImage {
        return UIImage.create(size: size) { (context) in
            let rect = size.rect
            
            tintColor.set()
            UIRectFill(rect)
            draw(in: rect, blendMode: .destinationIn, alpha: 1)
        }
    }
    
    public func createAsync(withTintColor tintColor: UIColor, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.userInitiated.async(execute: { self.with(tintColor: tintColor) },
                                          afterInMain: { completion($0) })
    }
    
    public func with(edgeInsets: UIEdgeInsets, backgroundColor: UIColor = .clear) -> UIImage {
        guard edgeInsets != .zero else { return self }
        
        let toSize = CGSize(width: size.width + edgeInsets.horizontal,
                            height: size.height + edgeInsets.vertical)
        
        return UIImage.create(size: toSize) { (context) in
            context.setFillColor(backgroundColor.cgColor)
            context.fill(toSize.rect)
            
            draw(at: edgeInsets.leftTop)
        }
    }
    
    public func createAsync(withEdgeInsets edgeInsets: UIEdgeInsets, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.userInitiated.async(execute: { self.with(edgeInsets: edgeInsets) },
                                          afterInMain: { completion($0) })
    }
    
    public func circled() -> UIImage {
        return UIImage.create(size: size) { (context) in
            UIBezierPath(ovalIn: CGRect(origin: CGPoint(), size: size)).addClip()
            draw(at: .zero)
        }
    }
    
    public func circledAsync(completion: @escaping (UIImage) -> Void) {
        DispatchQueue.userInitiated.async(execute: { self.circled() }, afterInMain: { completion($0) })
    }
    
    public func squareCircled() -> UIImage {
        let squareImage: UIImage = {
            guard size.width != size.height else { return self }
            
            let length = min(size.width, size.height)
            let toSize = CGSize(width: length, height: length)
            
            return self.resized(withAspectFillSize: toSize)
        }()
        
        return squareImage.circled()
    }
    
    public func squareCircledAsync(completion: @escaping (UIImage) -> Void) {
        DispatchQueue.userInitiated.async(execute: { self.squareCircled() }, afterInMain: { completion($0) })
    }
}

// MARK: - resizing
extension UIImage {
    public func resized(toSize: CGSize, scale: CGFloat? = nil) -> UIImage {
        let toScale = scale ?? self.scale
        guard toSize != size || toScale != self.scale else { return self }
        
        return UIImage.create(size: toSize, scale: toScale, draw: { (context) in
            draw(in: toSize.rect)
        })
    }
    
    public func resizedAsync(toSize: CGSize, scale: CGFloat? = nil, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.userInitiated.async(execute: { self.resized(toSize: toSize, scale: scale) },
                                          afterInMain: { completion($0) })
    }
    
    public func resized(withConstrainedPixel pixel: Int) -> UIImage {
        let toSize = size.resized(constrainedPixel: pixel, scale: scale)
        return self.resized(toSize: toSize, scale: scale)
    }
    
    public func resizedAsync(withConstrainedPixel pixel: Int, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.userInitiated.async(execute: { self.resized(withConstrainedPixel: pixel) },
                                          afterInMain: { completion($0) })
    }
    
    public func resized(withAspectFitSize fitSize: CGSize) -> UIImage {
        let toSize = size.resizedAspectFit(fitSize: fitSize)
        return self.resized(toSize: toSize)
    }
    
    public func resizedAsync(withAspectFitSize fitSize: CGSize, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.userInitiated.async(execute: { self.resized(withAspectFitSize: fitSize) },
                                          afterInMain: { completion($0) })
    }
    
    public func resized(withAspectFillSize fillSize: CGSize) -> UIImage {
        guard fillSize != size else { return self }
        
        return  UIImage.create(size: fillSize, draw: { (context) in
            let size = self.size
            let ratio = max(fillSize.width / size.width, fillSize.height / size.height)
            let toSize = size.resized(toScale: ratio)
            let rect = CGRect(x: fillSize.width |- toSize.width,
                              y: fillSize.height |- toSize.height,
                              width: toSize.width,
                              height: toSize.height)
            draw(in: rect)
        })
    }
    
    public func resizedAsync(withAspectFillSize fillSize: CGSize, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.userInitiated.async(execute: { self.resized(withAspectFillSize: fillSize) },
                                          afterInMain: { completion($0) })
    }
}
