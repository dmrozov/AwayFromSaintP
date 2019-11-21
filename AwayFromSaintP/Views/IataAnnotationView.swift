//
//  IataAnnotationView.swift
//  AwayFromSaintP
//
//  Created by Dmitry Rozov on 21/11/2019.
//  Copyright © 2019 Dmitry Rozov. All rights reserved.
//

import MapKit

class IataAnnotationView: MKAnnotationView {

    var iataAnnotation: IataAnnotation

    init(_ iataAnnotation: IataAnnotation, reuseIdentifier: String?) {
        self.iataAnnotation = iataAnnotation
        super.init(annotation: iataAnnotation, reuseIdentifier: reuseIdentifier)
        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        let label = UILabel(frame: CGRect(x: -25, y: -10, width: 47, height: 20))
        label.text = iataAnnotation.iata
        label.textColor = .systemBlue
        label.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        label.font = .systemFont(ofSize: 15, weight: .heavy)
        label.textAlignment = .center

        label.layer.borderColor = UIColor.systemBlue.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        addSubview(label)
    }
}

class IataAnnotation: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var iata: String

    init(coordinate: CLLocationCoordinate2D, iata: String) {
        self.coordinate = coordinate
        self.iata = iata
    }
}
