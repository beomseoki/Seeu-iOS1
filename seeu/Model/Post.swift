//
//  Post.swift
//  seeu
//
//  Created by 김범석 on 2024/02/02.
//

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
    var comments: [Comment]? // 댓글 배열 추가 
    
    // postId를 통해서 얻은 값들을 들어가보면 이제 키와 벨류 캡션,라이크 같은것들을 비교해서 값들을 뽑을 수 있는구조!
    //user: User,
    init(postId: String!, user: User, dictionary: Dictionary<String, AnyObject>) {
        
        self.postId = postId
        
        self.user = user
        
        if let commentsDict = dictionary["comments"] as? [String: Any] {
        self.comments = commentsDict.compactMap { (key, value) in
            // 각 댓글의 데이터를 확인하고 올바른 형식인지 확인한 후 Comment 객체로 변환하여 반환합니다.
            guard let commentData = value as? [String: Any] else { return nil }
            return Comment(user: self.user!, dictionary: commentData) // 변경된 초기화 메서드 호출
        }
        }

        
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
    
    func adjustLikes(addLike: Bool, completion: @escaping(Int) -> ()) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        if addLike {
            
            
            // 사용자의 좋아요에서 아이디를 기준으로 포스트 1
            USER_LIKES_REF.child(currentUid).updateChildValues([postId: 1]) { err, ref in
                
                // 게시글 좋아요인데, 쉽게 생각해서 post-likes를 만든 후 -> 게시글 아이디를 토대로 -> 소유자 아이디에 값을 1로 넣어주는거임
                POST_LIKES_REF.child(self.postId).updateChildValues([currentUid: 1]) { err, ref in
                    
                    // 위에 두 완료 블록들이 실행이 완료될 때 까지 밑에 설정들은 되지 않는거임
                    self.likes = self.likes + 1
                    self.didLike = true
                    completion(self.likes)
                    // 헷갈리기 방지를 위한 메모 / 아이디를 기준으로 게시글로 들어간 후 , 좋아요의 값을 얻어오는거임
                    POSTS_REF.child(self.postId).child("likes").setValue(self.likes)
                }
            }

        } else {
    
            // 사용자 좋아요 제거하기
            USER_LIKES_REF.child(currentUid).child(postId).removeValue { err, ref in
                
                // 게시글 좋아요 제거하기
                POST_LIKES_REF.child(self.postId).child(currentUid).removeValue { err, ref in
                    
                    guard self.likes > 0 else { return }
                    self.likes = self.likes - 1
                    self.didLike = false
                    completion(self.likes)

                    POSTS_REF.child(self.postId).child("likes").setValue(self.likes)

                    
                }
            }
            
            
        }
        
        
        
    }
    
    
    
    
}

