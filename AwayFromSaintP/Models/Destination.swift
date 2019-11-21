//
//  Destination.swift
//  AwayFromSaintP
//
//  Created by Dmitry Rozov on 20/11/2019.
//  Copyright © 2019 Dmitry Rozov. All rights reserved.
//

import Foundation

struct Destination: Codable {

    enum CodingKeys: String, CodingKey {
        case name, iata, location
        case airportName = "airport_name"
    }

    var name: String
    var iata: String
    var location: Location
    var airportName: String?
}

extension Destination {
    static var saintP: Destination {
        return Destination(name: "Санкт-Петербург",
                           iata: "LED",
                           location: Location(latitude: 59.9342, longitude: 30.3352),
                           airportName: "Пулково")
    }
}
