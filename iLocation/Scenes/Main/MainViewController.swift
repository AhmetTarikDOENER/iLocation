import UIKit
import MapKit
import Combine

final class MainViewController: UIViewController {
    lazy var mapView = MKMapView(frame: view.bounds)
    private var cancellables = Set<AnyCancellable>()
    private lazy var customLocationController = LocationCarouselController(scrollDirection: .horizontal)
    private let locationManager = CLLocationManager()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Search"
        textField.leftView = .init(frame: .init(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        
        return textField
    }()
    
    //  MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        requestUserLocation()
        mapView.delegate = self
        configureMapRegion()
        setupHierarchy()
        setupSearchUI()
        performLocalSearch()
        setupSearchTextPublisher()
        buildLocationCarousels()
        customLocationController.mainController = self
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
        configureMapRegion()
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchTextField.text
        request.region = mapView.region
        request.pointOfInterestFilter = .includingAll
        
        let localSearch = MKLocalSearch(request: request)
        localSearch.start { response, error in
            if let error = error {
                print("Failed local search", error)
                return
            }
            self.customLocationController.items.removeAll()
            self.mapView.removeAnnotations(self.mapView.annotations)
            response?.mapItems.forEach({ mapItem in
                let annotation = MKPointAnnotation()
                annotation.coordinate = mapItem.placemark.coordinate
                annotation.title = mapItem.name
                self.mapView.addAnnotation(annotation)
                self.customLocationController.items.append(mapItem)
            })
            DispatchQueue.main.async {
                self.customLocationController.collectionView.scrollToItem(at: [0, 0], at: .centeredHorizontally, animated: true)
            }
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
    }
    
    private func setupSearchUI() {
        view.addSubview(searchTextField)
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        let containerView = buildContainerView()
        view.addSubview(containerView)
        containerView.addSubview(searchTextField)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 50),
            searchTextField.topAnchor.constraint(equalTo: containerView.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            searchTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func setupSearchTextPublisher() {
        searchTextField.textPublisher
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .compactMap { $0 }
            .removeDuplicates()
            .filter({ !$0.isEmpty })
            .sink { [weak self] query in
                self?.performLocalSearch()
            }
            .store(in: &cancellables)
    }
    
    private func requestUserLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}

//  MARK: - CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            print("Success")
            mapView.showsUserLocation = true
        default:
            print("NO no")
            mapView.showsUserLocation = false
        }
    }
}
//  MARK: - UITextField+textPublisher
extension UITextField {
    var textPublisher: AnyPublisher<String?, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
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
    
    private func buildLocationCarousels() {
        let locationView = customLocationController.view!
        locationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locationView)
        NSLayoutConstraint.activate([
            locationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            locationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            locationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            locationView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.16)
        ])
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
        if (annotation is MKPointAnnotation) {
            let customAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotation_identifier")
            customAnnotationView.canShowCallout = true
            customAnnotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            return customAnnotationView
        }
        return nil
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
