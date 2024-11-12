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
                let placeMark = mapItem.placemark
                var addressString = ""
                if placeMark.subThoroughfare != nil {
                    addressString = placeMark.subThoroughfare! + " "
                }
                if placeMark.thoroughfare != nil {
                    addressString += placeMark.thoroughfare! + ", "
                }
                if placeMark.postalCode != nil {
                    addressString += placeMark.postalCode! + " "
                }
                if placeMark.locality != nil {
                    addressString += placeMark.locality! + ", "
                }
                if placeMark.administrativeArea != nil {
                    addressString += placeMark.administrativeArea! + " "
                }
                if placeMark.country != nil {
                    addressString += placeMark.country!
                }
                print(addressString)
                let annotation = MKPointAnnotation()
                annotation.coordinate = mapItem.placemark.coordinate
                annotation.title = mapItem.name
                self.mapView.addAnnotation(annotation)
            })
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
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
