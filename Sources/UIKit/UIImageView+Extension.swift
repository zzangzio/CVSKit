//
//  UIImageView+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 2018. 12. 8..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit

extension UIImageView {
    public static func autolayoutView(image: UIImage) -> Self {
        let imageView = self.autoLayoutView()
        imageView.image = image

        return imageView
    }
}

