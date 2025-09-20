import UIKit

final class NewsFeedVC: UICollectionViewController {
    
    private let postsLoader: NewsFeedLoader
    private let userLoader: UserProfileLoader
    private var posts: [Post]
    
    private var userIdToUsername: [Int: String] = [:]
    
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
                }
                
                var userIdToUsername: [Int: String] = [:]
                let dispatchGroup = DispatchGroup()
                
                for post in posts {
                    dispatchGroup.enter()
                    
                    self.userLoader.loadUser(with: post.userId) { user, error in
                        dispatchGroup.leave()
                        
                        userIdToUsername[post.userId] = user?.username ?? "Unknown User"
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    print("All task completed")
                    // self.activityIndicatorView.stopAnimating()
                    // self.posts = posts
                    self.userIdToUsername = userIdToUsername
                    self.collectionView.reloadData() // We are on Main Queue here, so no need to explicitly dispatch to Main Queue
                }
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NewsFeedCell.cellReuseID,
            for: indexPath
        ) as! NewsFeedCell
        
        let post = posts[indexPath.item]
        
        cell.post = post
        
        if let username = userIdToUsername[post.userId] {
            cell.username = username
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension NewsFeedVC: UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let dummyCell = NewsFeedCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
        let post = posts[indexPath.item]
        
        dummyCell.post = post
        
        if let username = userIdToUsername[post.userId] {
            dummyCell.username = username
        }
        
        dummyCell.layoutIfNeeded()
        
        let estimatedSize = dummyCell.systemLayoutSizeFitting(CGSize(width: view.frame.width, height: 300))
        
        return CGSize(width: view.frame.width, height: estimatedSize.height)
    }
}
