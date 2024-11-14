import UIKit
import MapKit
import SwiftUI

final class DirectionsViewController: UIViewController {
    private let mapView = MKMapView()
    private lazy var navigationBarView = UIView()
    
    //  MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupHierarchy()
        configureMapRegion()
        mapView.showsUserLocation = true
        configureFromToAnnotations()
        configureRequestForDirections()
    }
    
    //  MARK: - Private
    private func setupHierarchy() {
        view.addSubview(navigationBarView)
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        navigationBarView.translatesAutoresizingMaskIntoConstraints = false
        navigationBarView.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.5607843137, blue: 0.9647058824, alpha: 1)
        navigationBarView.setupShadow(opacity: 1, radius: 5)
        view.addSubview(navigationBarView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            navigationBarView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100)
        ])
    }
    
    private func configureMapRegion() {
        let centeredCoordinates = CLLocationCoordinate2D(latitude: 37.334774, longitude: -122.008992)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region =  MKCoordinateRegion(center: centeredCoordinates, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    private func configureFromToAnnotations() {
        let startingAnnotation = MKPointAnnotation()
        startingAnnotation.coordinate = .init(latitude: 37.78807, longitude: -122.50111)
        startingAnnotation.title = "Start"
        
        let endingAnnotation = MKPointAnnotation()
        endingAnnotation.coordinate = .init(latitude: 37.331352, longitude: -122.030331)
        endingAnnotation.title = "End"
        mapView.addAnnotations([startingAnnotation, endingAnnotation])
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    private func configureRequestForDirections() {
        let request = MKDirections.Request()
        let sourcePlacemark = MKPlacemark(coordinate: .init(latitude: 37.78807, longitude: -122.50111))
        request.source = .init(placemark: sourcePlacemark)
        let destinationPlacemark = MKPlacemark(coordinate: .init(latitude: 37.331352, longitude: -122.030331))
        request.destination = .init(placemark: destinationPlacemark)
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error = error {
                print("Failed to find route info: ", error)
                return
            }
            guard let route = response?.routes.first else { return }
            self.mapView.addOverlay(route.polyline)
        }
    }
}

//  MARK: - MKMapViewDelegate
extension DirectionsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = .systemRed
        polylineRenderer.lineWidth = 5
        
        return polylineRenderer
    }
}
//  MARK: - DirectionsProvider
struct DirectionsPreview: PreviewProvider {
    static var previews: some View {
        ContainerView()
            .ignoresSafeArea(.all)
//            .environment(\.colorScheme, .dark)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController { DirectionsViewController() }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    }
}
