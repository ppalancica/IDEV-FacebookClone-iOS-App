struct NewsFeedPosts: Decodable {
    let posts: [Post]
    
    struct Post: Decodable {
        let title: String
        let body: String
    }
}
