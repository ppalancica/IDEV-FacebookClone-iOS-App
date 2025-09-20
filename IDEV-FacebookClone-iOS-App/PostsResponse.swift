struct PostsResponse: Decodable {
    let posts: [Post]
}

struct Post: Decodable {
    let title: String
    let body: String
    let views: Int
    let userId: Int
    
    let reactions: Reactions
}
