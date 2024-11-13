import UIKit
import MapKit

final class LocationCarouselController: CustomListController<LocationCell, MKMapItem> {
    //  MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .clear
        
        let dummyPlacemark = MKPlacemark(coordinate: .init(latitude: 10, longitude: 55))
        let dummyMapItem = MKMapItem(placemark: dummyPlacemark)
        dummyMapItem.name = "Dummy Location Name"
        
        self.items = [dummyMapItem]
    }
}

//  MARK: - UICollectionViewDelegateFlowLayout
extension LocationCarouselController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: view.frame.width - 90, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
}
