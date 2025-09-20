import UIKit

final class PostDetailsVC: UIViewController {
    
    var post: Post!
    var username: String?
    var userImageData: Data?
    
    var onAvatarOrUsernameTapped: ((Int) -> Void)?
    
    private struct Constants {
        static let padding: CGFloat = 16
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
        label.textColor = .black
        return label
    }()
    
    let tagsLabel1: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return label
    }()
    
    let tagsLabel2: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return label
    }()
    
    let tagsLabel3: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return label
    }()
    
    let likesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.text = "90 Likes"
        return label
    }()
    
    let dislikesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.text = "10 Dislikes"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadPostContents()
    }
    
    private func setupUI() {
        navigationItem.title = "Post Details"
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        let userView = UIStackView(arrangedSubviews: [
            avatarImageView, usernameLabel
        ])
        userView.spacing = 8
        
        let tagsView = UIStackView(arrangedSubviews: [
            tagsLabel1, tagsLabel2, tagsLabel3, UIView()
        ])
        tagsView.spacing = 8
        
        let reactionsView = UIStackView(arrangedSubviews: [
            likesLabel, UIView(), dislikesLabel
        ])
        
        let stackView = UIStackView(arrangedSubviews: [
            userView,
            titleLabel,
            bodyLabel,
            UIStackView(arrangedSubviews: [
                viewsLabel, UIView()
            ]),
            tagsView,
            reactionsView,
            UIView() // The only difference comparing to NewsFeedCell
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        avatarImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.padding).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.padding).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.padding).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.padding).isActive = true
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(userAvatarOrUsernameTapped))
        userView.addGestureRecognizer(tapGR)
    }
    
    private func loadPostContents() {
        if let userImageData {
            avatarImageView.image = UIImage(data: userImageData)
        } else {
            avatarImageView.image = nil
        }
        if let username {
            usernameLabel.text = username
        } else {
            let userId = post.userId
            let username = userId > 0 ? "user\(userId)" : "Unknown User"
            usernameLabel.text = username
        }
        
        titleLabel.text = post.title
        bodyLabel.text = post.body
        let views = post.views
        let viewsText = views > 0 ? "\(views) users viewed this post" : "No user viewed this post"
        viewsLabel.text = "(" + viewsText + ")"
        
        if post.tags.count > 0 { tagsLabel1.text = post.tags[0] }
        if post.tags.count > 1 { tagsLabel2.text = post.tags[1] }
        if post.tags.count > 2 { tagsLabel3.text = post.tags[2] }
        
        likesLabel.text = "\(post.reactions.likes) Likes"
        dislikesLabel.text = "\(post.reactions.dislikes) Dislikes"
    }
    
    @objc private func userAvatarOrUsernameTapped() {
        onAvatarOrUsernameTapped?(post.userId)
    }
}
