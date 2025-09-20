import UIKit

final class NewsFeedCell: UICollectionViewCell {
    
    static let cellReuseID = "NewsFeedCell"
    
    struct Constants {
        static let padding: CGFloat = 16
    }
    
    var post: Post? {
        didSet {
            titleLabel.text = post?.title
            bodyLabel.text = post?.body
            let views = post?.views ?? 0
            let viewsText = views > 0 ? "\(views) users viewed this post" : "No user viewed this post"
            viewsLabel.text = viewsText
            let userId = post?.userId ?? 0
            let username = userId > 0 ? "user\(userId)" : "Unknown User"
            usernameLabel.text = username
        }
    }
    
    var username: String? {
        didSet {
            usernameLabel.text = username
        }
    }
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(white: 0.92, alpha: 1)
        imageView.layer.cornerRadius = 22
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        return label
    }()
    
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
        label.numberOfLines = 0
        return label
    }()
    
    let viewsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.backgroundColor = .white
        label.textColor = .black
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
        
        let userView = UIStackView(arrangedSubviews: [
            avatarImageView, usernameLabel
        ])
        userView.spacing = 8
        
        let stackView = UIStackView(arrangedSubviews: [
            userView,
            titleLabel,
            bodyLabel,
            UIStackView(arrangedSubviews: [
                viewsLabel, UIView()
            ])
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        avatarImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.padding).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding).isActive = true
    }
}
