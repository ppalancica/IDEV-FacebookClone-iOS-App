import UIKit

final class NewsFeedVC: UICollectionViewController {
    
    private let loader: NewsFeedLoader
    private var posts: [Post]
    
    init() {
        loader = NewsFeedLoader()
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
        
        loader.loadPosts { posts, error in
            if let posts {
                DispatchQueue.main.async {
                    self.posts = posts
                    self.collectionView.reloadData()
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
        dummyCell.layoutIfNeeded()
        
        let estimatedSize = dummyCell.systemLayoutSizeFitting(CGSize(width: view.frame.width, height: 300))
        
        return CGSize(width: view.frame.width, height: estimatedSize.height)
    }
}
