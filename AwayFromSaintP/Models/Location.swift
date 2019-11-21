//
//  Location.swift
//  AwayFromSaintP
//
//  Created by Dmitry Rozov on 20/11/2019.
//  Copyright © 2019 Dmitry Rozov. All rights reserved.
//

import MapKit

struct Location: Codable {

    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }

    var latitude: Double
    var longitude: Double
}

extension Location {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
