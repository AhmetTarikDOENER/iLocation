import UIKit

class CustomListCell<T>: UICollectionViewCell {
    var item: T!
    weak var parentController: UIViewController?
    let separatorView = UIView(backgroundColor: UIColor(white: 0.6, alpha: 0.5))
    
    func addSeparatorView(leadingAnchor: NSLayoutXAxisAnchor) {
        addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() { }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
