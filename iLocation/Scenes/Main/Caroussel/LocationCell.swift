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
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.65
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    
    private lazy var carousselStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .red
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
        clipsToBounds = true
        backgroundColor = .white
        layer.borderColor = UIColor.label.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 12
        setupShadow(opacity: 0.1, radius: 10, offset: .zero, color: .black)
    }
    
    private func configureViewHierarchy() {
        contentView.addSubview(carousselStackView)
        carousselStackView.addArrangedSubview(textLabel)
        NSLayoutConstraint.activate([
            carousselStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            carousselStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            carousselStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            carousselStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
