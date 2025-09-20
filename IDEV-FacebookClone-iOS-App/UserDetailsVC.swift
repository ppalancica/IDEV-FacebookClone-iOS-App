import UIKit

final class UserDetailsVC: UIViewController {
    
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = "User Details"
    }
}
