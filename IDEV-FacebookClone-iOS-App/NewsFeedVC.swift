import UIKit

final class NewsFeedVC: UICollectionViewController {
    
    private let postsLoader: NewsFeedLoader
    private let userLoader: UserProfileLoader
    private var posts: [Post]
    
    private var userIdToUsername: [Int: String] = [:]
    private var userIdToImageData: [Int: Data?] = [:]
    
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
                    
                    DispatchQueue.global(qos: .background).async {
                        self.loadUsernamesAndAvatars()
                    }
                }
            }
        }
    }
    
    private func loadUsernamesAndAvatars() {
        var userIdToUsername: [Int: String] = [:]
        var userIdToImageData: [Int: Data?] = [:]
        
        let dispatchGroup = DispatchGroup()
        
        for post in posts {
            dispatchGroup.enter()
            
            self.userLoader.loadUser(with: post.userId) { user, error in
                dispatchGroup.leave()
                
                userIdToUsername[post.userId] = user?.username ?? "Unknown User"
                
                if let userImage = user?.image {
                    let imageUrl = URL(string: userImage)!
                    let imageData = try? Data(contentsOf: imageUrl)
                    
                    userIdToImageData[post.userId] = imageData
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("All task completed")
            self.userIdToUsername = userIdToUsername
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
        
        if let username = userIdToUsername[post.userId] {
            cell.username = username
        }
        
        if let imageData = userIdToImageData[post.userId] {
            cell.userImageData = imageData
        }
        
        cell.onAvatarOrUsernameTapped = { [weak self] userId in
            print(userId)
            
            let userDetailsVC = UserDetailsVC()
            
            self?.navigationController?.pushViewController(userDetailsVC, animated: true)
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        
        let postDetailsVC = PostDetailsVC()
        postDetailsVC.post = posts[indexPath.item]
        
        navigationController?.pushViewController(postDetailsVC, animated: true)
    }
}

extension NewsFeedVC: UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let dummyCell = NewsFeedCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
        let post = posts[indexPath.item]
        
        dummyCell.post = post
        dummyCell.layoutIfNeeded()
        
        let estimatedSize = dummyCell.systemLayoutSizeFitting(CGSize(width: view.frame.width, height: 300))
        
        return CGSize(width: view.frame.width, height: estimatedSize.height)
    }
}
