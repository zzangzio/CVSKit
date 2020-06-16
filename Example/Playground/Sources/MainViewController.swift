//
//  MainViewController.swift
//  Playground
//
//  Created by zzangzio on 2018. 12. 9..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import CVSKit
import UIKit

class MainViewController: UIViewController {
    private let tableView = UITableView.autoLayoutView(.plain)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "CVSKit Playground"
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Main",
            style: .plain,
            target: nil,
            action: nil
        )
        view.addSubview(tableView)
        tableView.allConstraints(equalTo: view.safeAreaLayoutGuide).activate()

        tableView.dataSource = self
        tableView.delegate = self
    }

    private let playgroundViewControllerTypes: [PlaygroundViewController.Type] = {
        [
            LocalizableStringPlaygroundViewController.self,
            ValidEmailPlaygroundViewController.self,
            TintImagePlaygroundViewController.self,
            TransparentImagePlaygroundViewController.self,
            RotateAnimationPlaygroundViewController.self,
            PulseAnimationPlaygroundViewController.self,
            TabControlPlaygroundViewController.self,
            TabControlManyTabsPlaygroundViewController.self,
            ChameleonViewPlaygroundViewController.self,
            CircularProgressPlaygroundViewController.self,
            FragleWindowViewController.self,
        ]
    }()
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return playgroundViewControllerTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ActionTableViewCell = tableView.dequeueReusableCell()

        let playgroundViewControllerType = playgroundViewControllerTypes[indexPath.row]
        cell.title = playgroundViewControllerType.playgroundTitle
        cell.action = { [weak self] in
            guard let self = self else { return }
            guard let navigationController = self.navigationController else { return }
            navigationController.pushViewController(playgroundViewControllerType.init(), animated: true)
        }

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
