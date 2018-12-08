//
//  UILabel+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 2018. 12. 8..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit

extension UILabel {
    public static func autoLayoutView(font: UIFont?, color: UIColor?) -> Self {
        let label = self.autoLayoutView()
        label.textColor = color
        label.font = font

        return label
    }

    public convenience init(font: UIFont?, color: UIColor?) {
        self.init()
        textColor = color
        self.font = font
    }

    public func sizeToFit(constrainedWidth: CGFloat) {
        let numberOfLines = self.numberOfLines
        self.numberOfLines = 0
        var fitSize = sizeThatFits(CGSize(width: constrainedWidth, height: .greatestFiniteMagnitude))
        self.numberOfLines = numberOfLines

        if numberOfLines > 0 {
            fitSize.height = min(fitSize.height, ceil(self.font.lineHeight * CGFloat(numberOfLines)))
        }

        size = fitSize
    }
}

// MARK: - Measure
private var measureLabel = UILabel()
extension UILabel {
    public static func measureSize(withText text: String,
                                   font: UIFont,
                                   numberOfLines: Int,
                                   constrainedWidth: CGFloat,
                                   lineBreakMode: NSLineBreakMode = .byTruncatingTail) -> CGSize {
        measureLabel.text = text
        measureLabel.font = font
        measureLabel.numberOfLines = numberOfLines
        measureLabel.lineBreakMode = lineBreakMode

        measureLabel.sizeToFit(constrainedWidth: constrainedWidth)
        return measureLabel.size
    }

    static func measureSize(withAttributedString string: NSAttributedString,
                            numberOfLines: Int,
                            constrainedWidth: CGFloat,
                            lineBreakMode: NSLineBreakMode = .byTruncatingTail) -> CGSize {
        measureLabel.attributedText = string
        measureLabel.numberOfLines = numberOfLines
        measureLabel.lineBreakMode = lineBreakMode

        measureLabel.sizeToFit(constrainedWidth: constrainedWidth)
        return measureLabel.size
    }
}
