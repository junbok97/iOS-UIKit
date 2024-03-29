//
//  SFSymbolsCoordinator.swift
//  iOS UIKit
//
//  Created by 이준복 on 2023/05/09.
//

import UIKit

protocol SFSymbolsCoordinatorProtocol: CoordinatorProtocol {
    func start(_ buttonViewModel: ButtonViewModel)
}

final class SFSymbolsCoordinator: SFSymbolsCoordinatorProtocol {
    var parentCoordinator: CoordinatorProtocol?
    var childCoordinators: [CoordinatorProtocol] = []
    var navigationController: UINavigationController
    
    private let viewModel: SFSymbolsViewModel = SFSymbolsViewModel()

    init(
        _ navigationController: UINavigationController,
        _ parentCoordinator: CoordinatorProtocol?
    ) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let viewController = SFSymbolsViewController.create(self, viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func start(_ buttonViewModel: ButtonViewModel) {
        let viewController = SFSymbolsViewController.create(self, viewModel)
        viewController.bind(buttonViewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

}
