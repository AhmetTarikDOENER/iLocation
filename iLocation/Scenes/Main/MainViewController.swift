import UIKit
import MapKit

final class MainViewController: UIViewController {
    private lazy var mapView = MKMapView(frame: view.bounds)

    //  MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupHierarchy()
        configureMapRegion()
        setupMapAnnotation()
    }

    //  MARK: - Private
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
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region =  MKCoordinateRegion(center: centeredCoordinates, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    private func setupMapAnnotation() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 37.334774, longitude: -122.008992)
        annotation.title = "Apple"
        annotation.subtitle = "Cupertino, CA"
        
        let salesForceAnnotation = MKPointAnnotation()
        salesForceAnnotation.coordinate = CLLocationCoordinate2D(latitude: 37.79055, longitude: -122.38916)
        salesForceAnnotation.title = "Salesforce"
        salesForceAnnotation.subtitle = "Financial District, SF"
    
        mapView.addAnnotations([annotation, salesForceAnnotation])
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
}

//  MARK: - MKMapViewDelegate
extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        let customAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotation_identifier")
        customAnnotationView.canShowCallout = true
        customAnnotationView.image = UIImage(named: "map")
        
        return customAnnotationView
    }
}

//  MARK: - SWIFTUI Preview
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
