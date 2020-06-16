//
//  PlaygroundViewController.swift
//  Playground
//
//  Created by zzangzio on 2018. 12. 9..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit

class PlaygroundViewController: UIViewController {
    class var playgroundTitle: String {
        return "PlaygroundViewController"
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        title = type(of: self).playgroundTitle
    }
}
