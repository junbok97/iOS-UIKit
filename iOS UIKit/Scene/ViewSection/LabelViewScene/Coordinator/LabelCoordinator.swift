//
//  LabelCoordinator.swift
//  UIKit-Test
//
//  Created by 이준복 on 2023/04/12.
//

import UIKit

protocol LabelCoordinatorProtocol: CoordinatorProtocol {}

final class LabelCoordinator: LabelCoordinatorProtocol {
    var parentCoordinator: CoordinatorProtocol?
    var navigationController: UINavigationController
    var childCoordinators: [CoordinatorProtocol] = []
    
    init(
        _ navigationController: UINavigationController,
        _ parentCoordinator: CoordinatorProtocol?
    ) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let viewController = LabelViewController.create(self, LabelViewModel())
        navigationController.pushViewController(viewController, animated: true)
    }
    
}
