import UIKit

final class NewsFeedVC: UICollectionViewController {
    
    private let postsLoader: NewsFeedLoader
    private let userLoader: UserProfileLoader
    private var posts: [Post]
    
    private var userIdToUser: [Int: User] = [:]
    private var userIdToImageData: [Int: Data] = [:]
    
    init() {
        postsLoader = NewsFeedLoader()
        userLoader = UserProfileLoader()
        posts = []
        
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
        navigationItem.title = "News Feed"
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.hidesBackButton = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(NewsFeedCell.self, forCellWithReuseIdentifier: NewsFeedCell.cellReuseID)

        postsLoader.loadPosts { posts, error in
            // TODO: Handle errors
            
            if let posts {
                DispatchQueue.main.async {
                    self.posts = posts
                    self.collectionView.reloadData()
                    self.loadUsernamesAndAvatars() // Will do some additional loading in background
                }
            }
        }
    }
    
    private func loadUsernamesAndAvatars() {
        var userIdToUser: [Int: User] = [:]
        var userIdToImageData: [Int: Data] = [:]
        
        let dispatchGroup = DispatchGroup()
        
        for post in posts {
            dispatchGroup.enter()
            
            self.userLoader.loadUser(with: post.userId) { user, error in
                dispatchGroup.leave()
                
                userIdToUser[post.userId] = user
                
                if let userImage = user?.image, let imageUrl = URL(string: userImage) {
                    if let imageData = try? Data(contentsOf: imageUrl) {
                        userIdToImageData[post.userId] = imageData
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("All task completed")
            self.userIdToUser = userIdToUser
            self.userIdToImageData = userIdToImageData
            self.collectionView.reloadData() // We are on Main Queue here, so no need to explicitly dispatch to Main Queue
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NewsFeedCell.cellReuseID,
            for: indexPath
        ) as! NewsFeedCell
        
        let post = posts[indexPath.item]
        
        cell.post = post
        
        if let username = userIdToUser[post.userId]?.username {
            cell.username = username
        }
        
        if let imageData = userIdToImageData[post.userId] {
            cell.userImageData = imageData
        }
        
        cell.onAvatarOrUsernameTapped = { [weak self] userId in
            self?.navigateToUser(with: userId)
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        
        let postDetailsVC = PostDetailsVC()
        postDetailsVC.post = posts[indexPath.item]
        
        postDetailsVC.onAvatarOrUsernameTapped = { [weak self] userId in
            self?.navigateToUser(with: userId)
        }
        
        navigationController?.pushViewController(postDetailsVC, animated: true)
    }
    
    private func navigateToUser(with userId: Int) {
        print(userId)
        let userDetailsVC = UserDetailsVC()
        userDetailsVC.user = userIdToUser[userId]
        navigationController?.pushViewController(userDetailsVC, animated: true)
    }
}

extension NewsFeedVC: UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let dummyCell = NewsFeedCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1000))
        let post = posts[indexPath.item]
        
        dummyCell.post = post
        dummyCell.layoutIfNeeded()
        
        let estimatedSize = dummyCell.systemLayoutSizeFitting(CGSize(width: view.frame.width, height: 1000))
        
        return CGSize(width: view.frame.width, height: estimatedSize.height)
    }
}
