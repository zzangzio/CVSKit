//
//  UIImage+Face.swift
//  CVSKit
//
//  Created by zzangzio on 2020/06/15.
//  Copyright © 2020 zzangzio. All rights reserved.
//

import UIKit

private var faceImageKey = 0
public extension UIImage {
    func aroundFacesImage(to size: CGSize) -> UIImage? {
        return getFaceImage(key: "faces\(size)") { () -> Any in
            self.createAroundFacesImage(toSize: size) ?? "not found face"
        }
    }

    func aroundLargestFaceImage(to size: CGSize) -> UIImage? {
        return getFaceImage(key: "largestFace\(size)") { () -> Any in
            self.createAroundLargestFaceImage(toSize: size) ?? "not found face"
        }
    }

    private func getFaceImage(key: String, generator: () -> Any) -> UIImage? {
        var faceImages = objc_getAssociatedObject(self, &faceImageKey) as? [String: Any] ?? [:]
        if let faceImage = faceImages[key] {
            return faceImage as? UIImage
        }

        let faceImage = generator()
        faceImages[key] = faceImage
        objc_setAssociatedObject(self, &faceImageKey, faceImages, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        return faceImage as? UIImage
    }

    func faces(accuracy: String) -> [CIFeature]? {
        guard let ciImage = CIImage(image: self) else { return nil }
        guard let detector = CIDetector(
            ofType: CIDetectorTypeFace,
            context: nil,
            options: [CIDetectorAccuracy: accuracy]
        ) else { return nil }
        return detector.features(in: ciImage)
    }

    func largestFace(accuracy: String) -> CIFeature? {
        guard let faces = faces(accuracy: accuracy) else { return nil }

        var largestFace: CIFeature?

        faces.forEachStop { face, _, _ in
            guard let compareFace = largestFace else {
                largestFace = face
                return
            }
            let compareFaceArea = compareFace.bounds.size.width * compareFace.bounds.size.height
            let faceArea = face.bounds.size.width * face.bounds.size.height
            guard compareFaceArea < faceArea else {
                return
            }
            largestFace = face
        }
        return largestFace
    }

    func createAroundFacesImage(
        toSize: CGSize,
        accurancy: String = CIDetectorAccuracyHigh
    ) -> UIImage? {
        guard let faces = self.faces(accuracy: accurancy), faces.isEmpty == false else { return nil }

        let faceBounds = faces.reduce(faces[0].bounds) { (bounds, feature) -> CGRect in
            bounds.union(feature.bounds)
        }

        return createCroppedImage(withAround: faceBounds, toSize: toSize)
    }

    func createAroundLargestFaceImage(
        toSize: CGSize,
        accurancy: String = CIDetectorAccuracyHigh
    ) -> UIImage? {
        guard let largestFace = largestFace(accuracy: accurancy) else { return nil }

        return createCroppedImage(withAround: largestFace.bounds, toSize: toSize)
    }

    private func createCroppedImage(withAround around: CGRect, toSize: CGSize) -> UIImage? {
        guard size != .zero else { return nil }

        let pixelSize = CGSize(width: size.width * scale, height: size.height * scale)
        let pixelToSize: CGSize
        if size.width < toSize.width || size.height < toSize.height {
            let ratio = min(size.width / toSize.width, size.height / toSize.height)
            pixelToSize = CGSize(width: toSize.width * ratio * scale, height: toSize.height * ratio * scale)
        } else {
            pixelToSize = CGSize(width: toSize.width * scale, height: toSize.height * scale)
        }

        let x = min(pixelSize.width - pixelToSize.width, max(0, around.center.x - (pixelToSize.width / 2)))
        let y = min(
            pixelSize.height - pixelToSize.height,
            max(0, (pixelSize.height - around.center.y) - (pixelToSize.height / 2))
        )
        let cropRect = CGRect(x: x, y: y, width: pixelToSize.width, height: pixelToSize.height)

        guard let cgImage = self.cgImage?.cropping(to: cropRect) else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .up).resized(toSize: toSize)
    }
}
