import UIKit
import MapKit
import SwiftUI

final class DirectionsViewController: UIViewController {
    private let mapView = MKMapView()
    
    //  MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupNavigationBar()
        configureMapRegion()
        mapView.showsUserLocation = true
    }
    
    //  MARK: - Private
    private func setupHierarchy() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
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
    
    private func setupNavigationBar() {
        let navigationBarView = UIView()
        navigationBarView.translatesAutoresizingMaskIntoConstraints = false
        navigationBarView.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.5607843137, blue: 0.9647058824, alpha: 1)
        navigationBarView.setupShadow(opacity: 1, radius: 5)
        view.addSubview(navigationBarView)
        NSLayoutConstraint.activate([
            navigationBarView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100)
        ])
    }
}

//  MARK: - DirectionsProvider
struct DirectionsPreview: PreviewProvider {
    static var previews: some View {
        ContainerView()
            .ignoresSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController { DirectionsViewController() }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    }
}
