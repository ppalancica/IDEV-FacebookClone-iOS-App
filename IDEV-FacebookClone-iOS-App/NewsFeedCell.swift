import UIKit

final class NewsFeedCell: UICollectionViewCell {
    
    static let cellReuseID = "NewsFeedCell"
    
    struct Constants {
        static let padding: CGFloat = 8
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        return label
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 4
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            bodyLabel,
            UIView(),
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.padding).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.padding).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding).isActive = true
    }
}
