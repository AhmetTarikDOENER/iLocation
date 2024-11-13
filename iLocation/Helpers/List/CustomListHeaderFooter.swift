import UIKit

class CustomListHeaderFooterController<T: CustomListCell<U>, U, H: UICollectionReusableView, F: UICollectionReusableView>: UICollectionViewController {
    private let reuseIdentifier = "cell_identifier"
    private let supplementaryViewIdentifier = "supplementaryView_identifier"
    
    var items = [U]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func estimatedCellHeight(for indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        let cell = T()
        let largeHeight: CGFloat = 1000
        cell.frame = .init(x: 0, y: 0, width: cellWidth, height: largeHeight)
        cell.item = items[indexPath.item]
        cell.layoutIfNeeded()
        
        return cell.systemLayoutSizeFitting(.init(width: cellWidth, height: largeHeight)).height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #if os(iOS)
        if #available(iOS 13.0, *) {
            collectionView.backgroundColor = .systemBackground
        } else {
            collectionView.backgroundColor = .white
        }
        #endif
        collectionView.register(T.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(H.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: supplementaryViewIdentifier)
        collectionView.register(H.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: supplementaryViewIdentifier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! T
        cell.item = items[indexPath.row]
        cell.parentController = self
        
        return cell
    }
    
    func setupHeader(_ header: H) { }
    func setupFooter(_ footer: F) { }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: supplementaryViewIdentifier, for: indexPath)
        if let header = supplementaryView as? H {
            setupHeader(header)
        } else if let footer = supplementaryView as? F {
            setupFooter(footer)
        }
        
        return supplementaryView
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        view.layer.zPosition = -1
    }
    
    init(layout: UICollectionViewLayout = UICollectionViewFlowLayout(), scrollDirection: UICollectionView.ScrollDirection = .vertical) {
        if let layout = layout as? UICollectionViewFlowLayout {
            layout.scrollDirection = scrollDirection
        }
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
