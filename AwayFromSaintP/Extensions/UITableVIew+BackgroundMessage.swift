//
//  UITableVIew+BackgroundMessage.swift
//  AwayFromSaintP
//
//  Created by Dmitry Rozov on 21/11/2019.
//  Copyright © 2019 Dmitry Rozov. All rights reserved.
//

import UIKit.UITableView

extension UITableView {

    func addBackgroundMessageLabel(with text: String, isHidden: Bool = true) -> UILabel {
        let backgroundView = UIView()
        self.backgroundView = backgroundView

        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center

        backgroundView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 44).isActive = true
        label.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 16).isActive = true
        label.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -16).isActive = true
        return label
    }
}
