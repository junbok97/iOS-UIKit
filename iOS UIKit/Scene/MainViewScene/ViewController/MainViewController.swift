//
//  MainViewController.swift
//  UIKit-Test
//
//  Created by 이준복 on 2023/04/11.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class MainViewController: DefaultViewController {
    
    weak var coordinator: MainCoordinatorProtocol?
    
    private var viewModel: MainViewModel!
    
    static func create(
        _ viewModel: MainViewModel,
        _ coordinator: MainCoordinatorProtocol
    ) -> MainViewController {
        let mainViewController = MainViewController()
        mainViewController.viewModel = viewModel
        mainViewController.coordinator = coordinator
        mainViewController.bind()
        return mainViewController
    }
    
    private lazy var searchController: UISearchController = {
       let searchController = UISearchController()
        return searchController
    }()
    
    private lazy var objectListView: UITableView = {
       let tableView = UITableView()
        ObjectListCell.register(tableView: tableView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }
    
    func bind() {
        searchController.searchBar.rx.text
            .bind(to: viewModel.searchObject)
            .disposed(by: disposeBag)
        
        let dataSource = viewModel.dataSource()
        viewModel.cellData
            .drive(objectListView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        objectListView.rx.itemSelected
            .map { indexPath in
                dataSource.sectionModels[indexPath.section].items[indexPath.row]
            }
            .bind(to: self.rx.showDetailViewController)
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        super.attribute()
        setupNavigationItem()
    }
    
}

private extension MainViewController {
    func setupNavigationItem() {
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = MainViewControllerConstants.title
        navigationItem.searchController = searchController
    }
    
    func layout() {
        view.addSubview(objectListView)
        NSLayoutConstraint.activate([
            objectListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            objectListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            objectListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            objectListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func showDetailViewController(_ objectType: ObjectType) {
        self.coordinator?.pushDetailViewController(type: objectType)
    }

}

extension Reactive where Base: MainViewController {
    var showDetailViewController: Binder<ObjectType> {
        return Binder(base) { base, type in
            base.coordinator?.pushDetailViewController(type: type)
        }
    }
}
