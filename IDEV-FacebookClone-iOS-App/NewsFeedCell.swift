import UIKit

final class NewsFeedCell: UICollectionViewCell {
    
    static let cellReuseID = "NewsFeedCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
