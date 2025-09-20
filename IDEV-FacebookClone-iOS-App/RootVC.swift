import UIKit

final class RootVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let newsFeedVC = NewsFeedVC()
        
        navigationController?.pushViewController(newsFeedVC, animated: false)
    }
}
