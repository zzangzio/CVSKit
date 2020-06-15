//
//  ViewRecycler.swift
//  CVSKit
//
//  Created by zzangzio on 2020/06/15.
//  Copyright © 2020 zzangzio. All rights reserved.
//

import UIKit

public class ViewRecycler: NSObject {
    private var storeDic = [String: [UIView]]()

    public func enqueue(_ view: UIView) {
        let className = NSStringFromClass(type(of: view))
        enqueue(view, key: className)
    }

    public func enqueue(_ view: UIView, key: String) {
        var views = storeDic[key] ?? [UIView]()
        view.removeFromSuperview()
        views.append(view)
        storeDic[key] = views
    }

    public func dequeue<View: UIView>(initializer: (() -> View)) -> View {
        let className = NSStringFromClass(View.self)
        return dequeue(initializer: initializer, key: className)
    }

    public func dequeue<View: UIView>(initializer: (() -> View), key: String) -> View {
        if var views = storeDic[key] as? [View] {
            if views.isEmpty == false {
                defer { storeDic[key] = views }
                return views.removeFirst()
            }
        }
        return initializer()
    }

    public func dequeue<View: UIView>() -> View? {
        let className = String(describing: View.self)
        return dequeue(key: className)
    }

    public func dequeue<View: UIView>(key: String) -> View? {
        if var views = storeDic[key] as? [View] {
            if views.isEmpty == false {
                defer { storeDic[key] = views }
                return views.removeFirst()
            }
        }
        return nil
    }

    public func isEmpty(withView view: UIView) -> Bool {
        let className = NSStringFromClass(type(of: view))
        return isEmpty(withKey: className)
    }

    public func isEmpty(withKey key: String) -> Bool {
        if let views = storeDic[key] {
            return views.isEmpty
        }

        return true
    }
}
