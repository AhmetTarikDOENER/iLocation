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
        performLocalSearch()
        setupSearchUI()
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
    
    private func performLocalSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "apple"
        request.region = mapView.region
        let localSearch = MKLocalSearch(request: request)
        localSearch.start { response, error in
            if let error = error {
                print("Failed local search")
                return
            }
            response?.mapItems.forEach({ mapItem in
                print(mapItem.composeAddress())
                let annotation = MKPointAnnotation()
                annotation.coordinate = mapItem.placemark.coordinate
                annotation.title = mapItem.name
                self.mapView.addAnnotation(annotation)
            })
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
    }

    private func setupSearchUI() {
        let textField = buildTextField()
        let containerView = buildContainerView()
        view.addSubview(containerView)
        containerView.addSubview(textField)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 50),
            textField.topAnchor.constraint(equalTo: containerView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
}
//  MARK: - MainViewController+UIComponentBuilders
extension MainViewController {
    fileprivate func buildContainerView() -> UIView {
        let containerView = UIView()
        containerView.layer.cornerRadius = 12
        containerView.layer.borderColor = UIColor.label.cgColor
        containerView.layer.borderWidth = 0.5
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .systemBackground
        
        return containerView
    }
    
    fileprivate func buildTextField() -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Search"
        textField.leftView = .init(frame: .init(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        
        return textField
    }
}

//  MARK: - MKMapItem
extension MKMapItem {
    func composeAddress() -> String {
        let addressComponents = [
            placemark.subThoroughfare,
            placemark.thoroughfare,
            placemark.postalCode,
            placemark.locality,
            placemark.administrativeArea,
            placemark.country
        ]
        return addressComponents.compactMap { $0 }.joined(separator: ", ")
    }
}

//  MARK: - MKMapViewDelegate
extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        let customAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "annotation_identifier")
        customAnnotationView.canShowCallout = true
        customAnnotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

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
