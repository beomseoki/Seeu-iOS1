//
//  UserProfileVC.swift
//  seeu
//
//  Created by 김범석 on 2024/01/22.
//

import UIKit
import Firebase


private let reuseIdentifier = "Cell"
private let headerIdentifier = "UserProfileHeader"

class UserProfileVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - 속성표시
    
    var user: User?
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        
        // 배경 색
        self.collectionView.backgroundColor = .white
        
        // 사용자 데이터 가져와서 이제 비교함
        if self.user == nil {
            fetchCurrentUserData()
        }

        fetchPosts()
    }

    // MARK: UICollectionView

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! UserProfileHeader

        header.user = self.user
        self.navigationController?.navigationBar.topItem?.title = "프로필"
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 400)
    }

    // MARK: - database를 통한 API로 내 아이디 불러오기, 불러오고 게시글의 내용을 가져와서 적용하기 
    
    
    func fetchPosts() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        USER_POSTS_REF.child(currentUid).observe(.childAdded) { snapshot in
            let postId = snapshot.key
            
            Database.fetchPost(with: postId) { post in
                self.posts.append(post)
                self.posts.sort { post1, post2 in
                    post1.creationDate > post2.creationDate
                }
                self.collectionView.reloadData()
            }
            
        }
        
    }
    
    
    func fetchCurrentUserData() {

        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("user").child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            self.user = user
            self.navigationItem.title = user.name

            self.collectionView?.reloadData()
    
            
        }
        
        
    }

}
