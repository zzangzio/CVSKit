//
//  ActionTableViewCell.swift
//  Playground
//
//  Created by zzangzio on 2018. 12. 9..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit
import CVSKit

class ActionTableViewCell: UITableViewCell, ReusableViewCell {
    // MARK: - ReusableViewCell
    static let reuseIdentifier: String = ActionTableViewCell.description()

    var title: String? {
        set { textLabel?.text = newValue }
        get { return textLabel?.text }
    }

    var action: (() -> Void)? {
        didSet {

        }
    }
}
