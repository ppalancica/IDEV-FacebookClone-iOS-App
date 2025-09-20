import UIKit

final class NewsFeedLoader {
    
    func loadPosts() {
        let urlString = "https://dummyjson.com/posts"
        let url = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print("Error: ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                print("Error: Server response is not of type HTTPURLResponse")
                return
            }
            
            guard (200..<300).contains(response.statusCode) else {
                print("Error: Server response is not in (200..<300) range")
                return
            }
            
            guard let data else {
                print("Error: Server data unavailable")
                return
            }
            
            do {
                let posts = try JSONDecoder().decode(NewsFeedPosts.self, from: data)
                print(posts)
            } catch let jsonError {
                print("Error: ", jsonError)
            }
        }.resume()
    }
}
