import UIKit

final class RootVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let newsFeedVC = NewsFeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        
        navigationController?.pushViewController(newsFeedVC, animated: true)
    }
}
