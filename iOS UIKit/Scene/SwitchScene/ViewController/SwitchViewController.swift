//
//  SwitchViewController.swift
//  iOS UIKit
//
//  Created by 이준복 on 2023/05/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class SwitchViewController: DefaultListViewController {
    weak var coordinator: SwitchCoordinatorProtocol?
    private var viewModel: SwitchViewModel!
    private var dataSource: RxTableViewSectionedReloadDataSource<SwitchSettingListSectionModel>!
    
    static func create(
        _ viewModel: SwitchViewModel,
        _ coordinator: SwitchCoordinator
    ) -> SwitchViewController {
        let viewController = SwitchViewController()
        viewController.viewModel = viewModel
        viewController.coordinator = coordinator
        viewController.bind()
        return viewController
    }
    
    lazy var targetSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true
        toggle.onTintColor = .systemGreen
        toggle.thumbTintColor = .white
        toggle.backgroundColor = .secondarySystemBackground
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    @objc override func didTappedLeftBarButton() { coordinator?.finish() }
    
    func bind() {
        let dataSource = viewModel.switchSettingListDataSource()
        self.dataSource = dataSource
        
        viewModel.switchSettingListcellDatas
            .drive(settingList.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.targetOnTintColor
            .drive(self.rx.targetOnTintColor)
            .disposed(by: disposeBag)
        
        viewModel.targetThumbTintColor
            .drive(self.rx.targetThumbTintColor)
            .disposed(by: disposeBag)
        
        viewModel.targetBackgroundColor
            .drive(self.rx.targetBackgroundColor)
            .disposed(by: disposeBag)
        
        targetSwitch.rx.isOn
            .bind(to: viewModel.isOnDidChanged)
            .disposed(by: disposeBag)
        
        settingList
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        super.attribute()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = SwitchViewControllerConstants.title
        settingListConfigure()
    }
    
    override func layout() {
        super.layout()
        
        containerView.addSubview(targetSwitch)
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: SwitchViewControllerConstants.containerViewHeight),
            targetSwitch.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            targetSwitch.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    deinit {
        print("SwitchViewController")
    }
}

private extension SwitchViewController {
    func settingListConfigure() {
        SwitchCodeCell.register(tableView: settingList)
        SwitchColorCell.register(tableView: settingList)
    }
}
extension SwitchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = DefaultSettingListHeaderView()
        headerView.setupHeaderTitle(dataSource[section].sectionHeader.rawValue)
        return headerView
    }
}

extension Reactive where Base: SwitchViewController {
    var targetOnTintColor: Binder<UIColor> {
        Binder(base) { base, color in
            base.targetSwitch.onTintColor = color
        }
    }
    
    var targetThumbTintColor: Binder<UIColor> {
        Binder(base) { base, color in
            base.targetSwitch.thumbTintColor = color
        }
    }
    
    var targetBackgroundColor: Binder<UIColor> {
        Binder(base) { base, color in
            base.targetSwitch.backgroundColor = color
        }
    }
}