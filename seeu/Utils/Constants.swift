//
//  Constants.swift
//  seeu
//
//  Created by 김범석 on 2024/01/30.
//

import Firebase

let DB_REF = Database.database().reference()

let USER_REF = DB_REF.child("user") //users

let POSTS_REF = DB_REF.child("post") //posts


let USER_POSTS_REF = DB_REF.child("user-posts") // 게시하기 위한 내용들을 적어놓은 창들  

let USER_LIKES_REF = DB_REF.child("user-likes") // 좋아요 누른 사용자 확인하기위해서 먼저 설정해주기 
let POST_LIKES_REF = DB_REF.child("post-likes")
