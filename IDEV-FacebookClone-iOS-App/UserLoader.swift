import UIKit

final class UserProfileLoader {
    
    enum Error: Swift.Error {
        case serverError(String)
        case clientError(String)
        case unknown(String)
    }
    
    func loadUser(with userId: Int, completion: @escaping (User?, Error?) -> Void) {
        let urlString = "https://dummyjson.com/users/\(userId)"
        let url = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print("Error: ", error)
                completion(nil, .unknown(error.localizedDescription))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                completion(nil, .serverError("Server response is not of type HTTPURLResponse"))
                return
            }
            
            guard (200..<300).contains(response.statusCode) else {
                completion(nil, .serverError("Server response is not in (200..<300) range"))
                return
            }
            
            guard let data else {
                completion(nil, .serverError("Server data unavailable"))
                return
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(user, nil)
            } catch let jsonError {
                completion(nil, .clientError(jsonError.localizedDescription))
            }
        }.resume()
    }
}
