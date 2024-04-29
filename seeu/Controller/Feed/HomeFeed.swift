//
//  HomeFeed.swift
//  seeu
//
//  Created by 김범석 on 2024/02/15.
//

import UIKit
import Firebase
import Kingfisher

class HomeFeed: UITableViewController, MainCellDelegate {
    
    var posts = [Post]()
    var post: Post?
    var currentKey: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLogoutButton()
        self.tableView.separatorStyle = .none
        
        // 테이블 뷰에 쓸 cell등록
        self.tableView.register(MainCell.self, forCellReuseIdentifier: "MainCell")
        self.tableView.reloadData()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        fetchPost() // 데이터 불러오기

    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        posts.removeAll() // 현재 posts 배열 비우기
//        fetchPost() // 데이터 불러오기
//    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainCell
        
        cell.delegate = self
        
        let post = posts[indexPath.row]
        cell.post = post
        
        // 이미지 로드 및 업데이트
        if let profileImageUrl = post.user?.profileImageUrl { // 수정된 부분: post에서 user의 profileImageUrl 가져옴
            cell.profileImageView.kf.setImage(with: URL(string: profileImageUrl)) { result in
                switch result {
                case .success(_):
                    // 이미지 로딩이 완료되면 셀을 업데이트
                    cell.setNeedsLayout()
                case .failure(let error):
                    print("Error loading image: \(error)")
                }
            }
        }
        
        // 댓글 수 업데이트
        if let commentCount = post.comments?.count {
            cell.configureCommentCount(commentCount: commentCount)
        }
        
        return cell
    }



    
    // MARK: - MainCell Protocol
    
    func handleUsernameTapped(for cell: MainCell) {
        
        // 현재 MainCell 을 참조하고 있기 때문에 우리는 메인셀에 있는 post에 셀들을 가져올 수 있는거임 
        guard let post = cell.post else { return }
        
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        
        userProfileVC.user = post.user
        
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    func handleLikeTapped(for cell: MainCell) {
        guard let post = cell.post else { return }
        
        
        if post.didLike {
            // 좋아요 삭제
            post.adjustLikes(addLike: false) { likes in
                cell.likesLabel.text = "\(likes)"
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
            }

        } else {
            // 좋아요 클릭 가능 
            post.adjustLikes(addLike: true) { likes in
                cell.likesLabel.text = "\(likes)"
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_selected"), for: .normal)
            }
        }
    }

    
    func handleCommentTapped(for cell: MainCell) {
        guard let postId = cell.post?.postId else { return }
        
        // 선택된 게시물의 정보 가져오기
        Database.fetchPost(with: postId) { post in
            
            // 해당 게시물의 댓글 가져오기
            Database.fetchComments(forPost: postId) { comments in
                // 댓글이 성공적으로 가져와지면 DetailVC로 이동하고 게시물과 댓글 정보를 전달
                let detailVC = DetailVC(postId: postId)
                detailVC.post = post
                detailVC.comments = comments
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }

        
    // MARK: - 기능 탐색, 구성 / 로그인 기능 탐색하고 로그아웃하려고
    func configureLogoutButton() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout)) // 로그아웃 버튼을 눌렀을때 이제 액션에 있는 핸들에 대한 오브젝트쪽함수가 실행
        
        self.navigationItem.title = "커뮤니티"
        
      
        
        
        
    }
    
    //
    
    
    @objc func handleRefresh() {
        posts.removeAll(keepingCapacity: false)
        self.currentKey = nil
        fetchPost()
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    

    
    @objc func handleLogout() {
        
        // 로그아웃 할때 상태창 같은거
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 로그아웃 상태창을 이제 행동으로 더해서 보여주는거임 위에는 컨트롤러로 움직여주기때문에 여기에 addaction을 통해 더해줘야지
        alertController.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (_) in
            
            do {
                
                //이제 로그인 상태에 대해서 로그아웃을 하는거기때문에 throws를 사용하고 그래서 do,catch문을 사용한듯 , 그리고 로그인 , 로그아웃에 대한 내용이 들어가기때문에 3가지의 문장을 사용하는듯
                try Auth.auth().signOut()  // 로그아웃 하는 문장
                
                // 현재 로그인 정보가 있음을 알려주는 로그와 컨트롤러 제시
                
                let loginVC = LoginVC()
                let navController = UINavigationController(rootViewController: loginVC) // 로그인 네비게이션으로 변경해주는거임,  그리고 이렇게 해줬으니깐 로그인 화면이랑 연결돼어서 안되면 일로 다시 넘어가는거임
                // 그 다음에 네비게이션으로 변경 해줬으니깐 이제 보내줘야지
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
                
                
                //*self.navigationController?.pushViewController(navController, animated: true)
            
                print("로그아웃 성공")
                
                
            } catch {
                
                // 만약 에러가 떳을때 (로그아웃이 안돼서)
                print("로그아웃 실패")
                
            }
            
        }))
        
        // 취소 옵션을 추가해주기 (즉 로그아웃 할거냐?, 아니면 잘못눌렀으니 취소 ? 이렇게) , 위에는 로그아웃에 대한 내용, 이거는 취소에 대한 내용
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: - API



    func fetchPost() {
        POSTS_REF.observe(.childAdded) { [weak self] (snapshot) in
            guard let self = self else { return }
            let postId = snapshot.key
            Database.fetchPost(with: postId) { post in
                // 새로운 게시물을 배열에 추가
                self.posts.append(post)

                // 게시물을 가져온 후에 정렬
                self.posts.sort { $0.creationDate > $1.creationDate }

                // 테이블 뷰 리로드
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

                // 게시물 작성자의 UID를 사용하여 사용자 정보를 가져옴
                Database.fetchUser(with: post.ownerUid) { user in
                    // 사용자 정보를 가져온 후에 셀에 적용
                    guard let index = self.posts.firstIndex(where: { $0.postId == postId }) else { return }
                    let indexPath = IndexPath(row: index, section: 0)
                    DispatchQueue.main.async {
                        if let cell = self.tableView.cellForRow(at: indexPath) as? MainCell {
                            // 이미지 로딩 중에도 해당 셀이 여전히 유효한지 확인
                            guard cell.post?.postId == postId else { return }

                            // Kingfisher 이미지 다운로드 작업 취소
                            cell.profileImageView.kf.cancelDownloadTask()

                            // 이미지가 로드되지 않은 경우에만 이미지 설정
                            if cell.profileImageView.image == nil {
                                // 프로필 이미지 설정
                                if let profileImageUrl = user.profileImageUrl {
                                    cell.profileImageView.kf.setImage(with: URL(string: profileImageUrl)) { result in
                                        switch result {
                                        case .success(_):
                                            // 이미지 로딩이 완료되면 셀을 업데이트
                                            cell.setNeedsLayout()
                                        case .failure(let error):
                                            print("Error loading image: \(error)")
                                        }
                                    }
                                } else {
                                    // 프로필 이미지가 없는 경우 기본 이미지 설정
                                    cell.profileImageView.image = UIImage(named: "default_profile_image")
                                }
                            }
                            // 바뀌는 모습을 보고 싶어 .......?
                            cell.usernameButton.setTitle(user.name, for: .normal)
                        }
                    }
                }
            }
        }
    }































    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = posts[indexPath.row]
        
        guard let postId = selectedPost.postId else { return }
        
        // 선택된 게시물의 정보 가져오기
        Database.fetchPost(with: postId) { post in
            
            // 해당 게시물의 댓글 가져오기
            Database.fetchComments(forPost: postId) { comments in
                // 댓글이 성공적으로 가져와지면 DetailVC로 이동하고 게시물과 댓글 정보를 전달
                let detailVC = DetailVC(postId: postId)
                detailVC.post = post
                detailVC.comments = comments
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }

    }



