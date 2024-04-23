import Foundation
import Firebase

class Post {
    var caption: String!
    var likes: Int!
    var ownerUid: String!
    var creationDate: Date!
    var postId: String!
    var user: User?
    var didLike = false
    var comments: [Comment]?

    init(postId: String, user: User, dictionary: [String: Any], comments: [Comment]? = nil) {
        self.postId = postId
        self.user = user
        self.comments = comments
        
        if let caption = dictionary["caption"] as? String {
            self.caption = caption
        }
        
        if let likes = dictionary["likes"] as? Int {
            self.likes = likes
        }
        
        if let ownerUid = dictionary["ownerUid"] as? String {
            self.ownerUid = ownerUid
        }
        
        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
    }
    
    func adjustLikes(addLike: Bool, completion: @escaping (Int) -> ()) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        if addLike {
            USER_LIKES_REF.child(currentUid).updateChildValues([postId: 1]) { [weak self] (_, _) in
                guard let self = self else { return }
                POST_LIKES_REF.child(self.postId).updateChildValues([currentUid: 1]) { (_, _) in
                    self.likes += 1
                    self.didLike = true
                    completion(self.likes)
                    POSTS_REF.child(self.postId).child("likes").setValue(self.likes)
                }
            }
        } else {
            USER_LIKES_REF.child(currentUid).child(postId).removeValue { [weak self] (_, _) in
                guard let self = self else { return }
                POST_LIKES_REF.child(self.postId).child(currentUid).removeValue { (_, _) in
                    guard self.likes > 0 else { return }
                    self.likes -= 1
                    self.didLike = false
                    completion(self.likes)
                    POSTS_REF.child(self.postId).child("likes").setValue(self.likes)
                }
            }
        }
    }
}
