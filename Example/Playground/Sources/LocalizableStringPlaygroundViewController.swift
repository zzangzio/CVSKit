//
//  LocalizableStringPlaygroundViewController.swift
//  Playground
//
//  Created by zzangzio on 2018. 12. 9..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit
import CVSKit

class LocalizableStringPlaygroundViewController: PlaygroundViewController {
    override class var playgroundTitle: String {
        return "Localizable String"
    }

    static var entryCount = 0
    private let tableView = UITableView.autoLayoutView(.plain)

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        LocalizableStringPlaygroundViewController.entryCount += 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(tableView)
        tableView.allConstraints(equalTo: view.backportSafeAreaLayoutGuide).activate()

        tableView.dataSource = self
        tableView.delegate = self
    }

    private lazy var dataSource: [(title: String, action: (() -> Void)?)] = {
        guard let navigationController = self.navigationController else { return [] }

        return [("entryCount".localized(with: LocalizableStringPlaygroundViewController.entryCount), nil),
                ("showAlert".localized(),
                 { UIAlertController.alert(withTitle: "warning".localized(), message: nil)
                    .addDefaultAction(title: "ok".localized())
                    .addCancelAction(title: "cancel".localized())
                    .addDestructiveAction(title: "remove".localized())
                    .presented(on: self)
                }),
        ]
    }()
}

// MARK: - UITableViewDataSource
extension LocalizableStringPlaygroundViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ActionTableViewCell = tableView.dequeueReusableCell()

        let dataSource = self.dataSource[indexPath.row]
        cell.title = dataSource.title
        cell.action = dataSource.action

        return cell
    }
}

// MARK: - UITableViewDelegate
extension LocalizableStringPlaygroundViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard let actionCell = tableView.cellForRow(at: indexPath) as? ActionTableViewCell,
            actionCell.action != nil else { return false }
        return true
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let actionCell = tableView.cellForRow(at: indexPath) as? ActionTableViewCell else { return }
        actionCell.action?()
    }
}
