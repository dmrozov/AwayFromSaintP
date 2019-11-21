//
//  DestinationTableViewCell.swift
//  AwayFromSaintP
//
//  Created by Dmitry Rozov on 20/11/2019.
//  Copyright © 2019 Dmitry Rozov. All rights reserved.
//

import UIKit

class DestinationTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var iataLabel: UILabel!

    var viewModel: DestinationCellModel! {
        didSet {
            nameLabel.text = viewModel.name
            infoLabel.text = viewModel.info
            iataLabel.text = viewModel.iata
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        nameLabel.text = nil
        infoLabel.text = nil
        iataLabel.text = nil
    }
}

struct DestinationCellModel {

    var name = ""
    var info = ""
    var iata = ""

    init(destination: Destination) {
        name = destination.name
        info = destination.airportName ?? "Все аэропорты"
        iata = destination.iata
    }
}
