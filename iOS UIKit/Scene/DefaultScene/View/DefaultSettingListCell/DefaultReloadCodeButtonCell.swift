//
//  DefaultReloadCodeButtonCell.swift
//  iOS UIKit
//
//  Created by 이준복 on 2023/05/23.
//

import UIKit

class DefaultReloadCodeButtonCell: DefaultCell {
    
    class override var cellId: String {
        get { DefaultReloadCodeButtonCellConstants.cellId }
    }
    
    weak var tableView: UITableView?
    var section: Int = DefaultReloadCodeButtonCellConstants.section
    
    lazy var reloadButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.title = DefaultReloadCodeButtonCellConstants.buttonTitle
        button.configuration = configuration
        button.addTarget(self, action: #selector(reloadButtonDidTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setTableViewAndSection(
        _ tableView: UITableView,
        _ section: Int
    ) {
        self.tableView = tableView
        self.section = section
    }
    
    override func layout() {
        super.layout()
        
        contentView.addSubview(reloadButton)
        
        NSLayoutConstraint.activate([
            reloadButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: DefaultViewControllerConstants.defaultOffset),
            reloadButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: DefaultViewControllerConstants.defaultOffset),
            reloadButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -DefaultViewControllerConstants.defaultOffset),
            reloadButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -DefaultViewControllerConstants.defaultOffset)
        ])

    }
}

private extension DefaultReloadCodeButtonCell {
    @objc func reloadButtonDidTapped() {
        tableView?.reloadSections([section], animationStyle: .automatic)
    }
}
