import UIKit
import MapKit

final class MainViewController: UIViewController {
    private lazy var mapView = MKMapView(frame: view.bounds)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        configureMapRegion()
    }

    private func setupHierarchy() {
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureMapRegion() {
        let centeredCoordinates = CLLocationCoordinate2D(latitude: 37.334774, longitude: -122.008992)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.01)
        let region =  MKCoordinateRegion(center: centeredCoordinates, span: span)
        mapView.setRegion(region, animated: true)
    }
}

import SwiftUI

struct MainPreview: PreviewProvider {
    static var previews: some View {
        ContainerView()
            .ignoresSafeArea()
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        typealias UIViewControllerType = MainViewController
        
        func makeUIViewController(context: Context) -> MainViewController { 
            MainViewController()
        }
        
        func updateUIViewController(_ uiViewController: MainViewController, context: Context) { }
    }
}
