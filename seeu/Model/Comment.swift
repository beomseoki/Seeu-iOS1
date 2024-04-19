//
//  Comment.swift
//  seeu
//
//  Created by 김범석 on 2024/03/28.
//

import Foundation
import Firebase


// DetailVC에서 사용하기 편하게 데이터를 가져오려는 파일을 생성 
class Comment {
    
    var uid: String
    var commentText: String
    var creationDate: Date
    var user: User?
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        
        // uid, commentText, creationDate를 옵셔널 타입이 아닌 일반 타입으로 변경
        if let uid = dictionary["uid"] as? String {
            self.uid = uid
        } else {
            self.uid = ""
        }
        
        if let commentText = dictionary["commentText"] as? String {
            self.commentText = commentText
        } else {
            self.commentText = ""
        }
        
        if let creationDate = dictionary["creationDate"] as? TimeInterval {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        } else {
            self.creationDate = Date()
        }
    }
}

    
    // 수정중
    //댓글을 작성한 사용자에 따라 uid, text, date 생성
//    init(user: User, dictionary: Dictionary<String, AnyObject>) {
//
//        self.user = user
//
//        if let uid = dictionary["uid"] as? String {
//            self.uid = uid
//        }
//
//        if let commentText = dictionary["commentText"] as? String {
//            self.commentText = commentText
//        }
//
//        if let creationDate = dictionary["creationDate"] as? Double {
//            self.creationDate =  Date(timeIntervalSince1970: creationDate)
//        }
//
//    }
    
    
    
    
    

