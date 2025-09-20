import UIKit

final class PostDetailsVC: UIViewController {
    
    var post: Post!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = "Post Details"
    }
}
