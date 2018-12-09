//
//  MainViewController.swift
//  Playground
//
//  Created by zzangzio on 2018. 12. 9..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit
import CVSKit

class MainViewController: UIViewController {
    private let tableView = UITableView.autoLayoutView(.plain)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "CVSKit Playground"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Main",
                                                           style: .plain,
                                                           target: nil, action: nil)
        view.addSubview(tableView)
        tableView.allConstraints(equalTo: view.backportSafeAreaLayoutGuide).activate()

        tableView.dataSource = self
        tableView.delegate = self
    }

    private lazy var dataSource: [(title: String, action: () -> Void)] = {
        guard let navigationController = self.navigationController else { return [] }

        return [
            ("Localizable String Playground", {
                let vc = LocalizableStringPlaygroundViewController(title: "Localizable String Playground")
                navigationController.pushViewController(vc, animated: true)
            }),
            ("Valid Email Check Playground", {
                let vc = ValidEmailPlaygroundViewController(title: "Valid Email Check Playground")
                navigationController.pushViewController(vc, animated: true)
            }),
            ("Valid Email Check Playground", {
                let vc = ValidEmailPlaygroundViewController(title: "Valid Email Check Playground")
                navigationController.pushViewController(vc, animated: true)
            }),
        ]
    }()
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
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
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let actionCell = tableView.cellForRow(at: indexPath) as? ActionTableViewCell else { return }
        actionCell.action?()
    }
}
