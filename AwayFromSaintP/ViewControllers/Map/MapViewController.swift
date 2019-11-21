//
//  MapViewController.swift
//  AwayFromSaintP
//
//  Created by Dmitry Rozov on 20/11/2019.
//  Copyright © 2019 Dmitry Rozov. All rights reserved.
//

import UIKit
import MapKit

private let pointIdentifier = "pointIdentifier"
private let planeIdentifier = "planeIdentifier"

class MapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var messageLabel: UILabel! {
        didSet {
            messageLabel.text = "ЛЕТИМ В \(destination.name.uppercased())!"
        }
    }
    
    private var flightpathPolyline: MKGeodesicPolyline!
    private let planeAnnotation = MKPointAnnotation()
    lazy var planeAnnotationView: MKAnnotationView? = {
        let planeAnnotationView = MKAnnotationView(annotation: planeAnnotation, reuseIdentifier: planeIdentifier)
        planeAnnotationView.image = #imageLiteral(resourceName: "plane.pdf")
        return planeAnnotationView
    }()
    private var planeAnnotationPosition = 0
    private var planeDirection: CLLocationDirection!

    var destination: Destination!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureMapAttributes()
        updatePlanePosition()
    }

    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }

    private func configureMapAttributes() {
        let coordinates = [Destination.saintP.location.coordinate,
                           destination.location.coordinate]
        let polyLine = MKGeodesicPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyLine)
        flightpathPolyline = polyLine

        var iataAnnotations = [IataAnnotation]()
        iataAnnotations.append(IataAnnotation(coordinate: Destination.saintP.location.coordinate,
                                          iata: Destination.saintP.iata))
        iataAnnotations.append(IataAnnotation(coordinate: destination.location.coordinate,
        iata: destination.iata))
        iataAnnotations.forEach { mapView.addAnnotation($0) }
        mapView.showAnnotations(iataAnnotations, animated: false)

        mapView.addAnnotation(planeAnnotation)
    }

    private func updatePlanePosition() {
        let step = 5
        guard planeAnnotationPosition + step < flightpathPolyline.pointCount
            else {
                hidePlaneAnnotationWithAnimation()
                return
        }

        let points = flightpathPolyline.points()
        let previousMapPoint = points[planeAnnotationPosition]
        self.planeAnnotationPosition += step
        let nextMapPoint = points[planeAnnotationPosition]

        self.planeDirection = directionBetweenPoints(previousMapPoint, nextMapPoint)

        planeAnnotationView?.transform = mapView.transform.rotated(by: CGFloat(degreesToRadians(planeDirection)))

        UIView.animate(withDuration: 0.1, animations: {
            self.planeAnnotation.coordinate = nextMapPoint.coordinate
        }) { (_) in
            self.updatePlanePosition()
        }
    }

    private func hidePlaneAnnotationWithAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            if let planeAnnotationView = self.planeAnnotationView {
                planeAnnotationView.transform = planeAnnotationView.transform.scaledBy(x: 0.01, y: 0.01)
            }
        }, completion: { (_) in
            self.mapView.removeAnnotation(self.planeAnnotation)
            self.planeAnnotationView = nil
            self.dismiss(animated: true)
        })
    }

    // MARK: - Calculations

    private func directionBetweenPoints(_ sourcePoint: MKMapPoint, _ destinationPoint: MKMapPoint) -> CLLocationDirection {
        let x = destinationPoint.x - sourcePoint.x
        let y = destinationPoint.y - sourcePoint.y
        return radiansToDegrees(atan2(y, x)).truncatingRemainder(dividingBy: 360 + 90)
    }

    private func radiansToDegrees(_ radians: Double) -> Double {
        return radians * 180 / .pi
    }

    private func degreesToRadians(_ degrees: Double) -> Double {
        return degrees * .pi / 180
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }

        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 3.0
        renderer.alpha = 0.5
        renderer.strokeColor = .systemBlue
        renderer.lineDashPattern = [0, 5]
        return renderer
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let iataAnnotation = annotation as? IataAnnotation {
            let pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: planeIdentifier) ?? IataAnnotationView(iataAnnotation, reuseIdentifier: planeIdentifier)
            return pinAnnotationView
        }
        return planeAnnotationView
    }
}
