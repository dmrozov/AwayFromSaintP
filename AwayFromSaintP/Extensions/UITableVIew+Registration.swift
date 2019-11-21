//
//  UITableVIew+Registration.swift
//  AwayFromSaintP
//
//  Created by Dmitry Rozov on 20/11/2019.
//  Copyright © 2019 Dmitry Rozov. All rights reserved.
//

import UIKit.UITableView

extension UITableView {

    func registerNibs(for cellClasses: [UITableViewCell.Type]) {
        cellClasses.forEach {
            register($0.nib, forCellReuseIdentifier: $0.identifier)
        }
    }
}
