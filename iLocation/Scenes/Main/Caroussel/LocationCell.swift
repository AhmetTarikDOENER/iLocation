import UIKit
import MapKit

final class LocationCell: CustomListCell<MKMapItem> {
    
    override var item: MKMapItem! {
        didSet {
            textLabel.text = item.name
        }
    }
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Location"
        label.font = .boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    private lazy var carousselStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 15, left: 15, bottom: 15, right: 15)
        
        return stackView
    }()
    
    override func setupViews() {
        setupInitialCellUI()
        configureViewHierarchy()
    }
    
    private func setupInitialCellUI() {
        backgroundColor = .white
        layer.borderColor = UIColor.label.cgColor
        layer.borderWidth = 0.5
        self.layer.cornerRadius = 12
        setupShadow(opacity: 0.1, radius: 10, offset: .zero, color: .black)
    }
    
    private func configureViewHierarchy() {
        contentView.addSubview(carousselStackView)
        carousselStackView.addArrangedSubview(textLabel)
    }
}
