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
    var didLoadData: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLogoutButton()
        self.tableView.separatorStyle = .none
        
        // 테이블 뷰에 쓸 cell 등록
        self.tableView.register(MainCell.self, forCellReuseIdentifier: "MainCell")
        self.tableView.reloadData()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        if !didLoadData {
            fetchPost() // 데이터를 처음 읽을 때 호출
            didLoadData = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainCell
        let post = posts[indexPath.row]
        cell.post = post
        cell.delegate = self

        // 사용자 정보를 비동기적으로 로드하고 셀에 설정
        Database.fetchUser(with: post.ownerUid) { user in
            DispatchQueue.main.async {
                guard let visibleCell = self.visibleCell(for: post.postId) else { return }

                // 셀이 여전히 화면에 표시되는지 확인
                guard let currentPost = visibleCell.post, currentPost.postId == post.postId else { return }

                // 사용자 이름과 이미지 설정
                visibleCell.usernameButton.setTitle(user.name, for: .normal)
                if let profileImageUrl = user.profileImageUrl, let url = URL(string: profileImageUrl) {
                    visibleCell.profileImageView.kf.setImage(with: url)
                } else {
                    visibleCell.profileImageView.image = UIImage(named: "default_profile_image")
                }
            }
        }

        // 댓글 수 업데이트
        if let commentCount = post.comments?.count {
            cell.configureCommentCount(commentCount: commentCount)
        }

        return cell
    }
    
    private func visibleCell(for postId: String) -> MainCell? {
        guard let indexPaths = tableView.indexPathsForVisibleRows else { return nil }

        for indexPath in indexPaths {
            if let cell = tableView.cellForRow(at: indexPath) as? MainCell, cell.post?.postId == postId {
                return cell
            }
        }
        return nil
    }

    // MARK: - MainCell Protocol
    
    func handleUsernameTapped(for cell: MainCell) {
        guard let post = cell.post else { return }
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileVC.user = post.user
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    func handleLikeTapped(for cell: MainCell) {
        guard let post = cell.post else { return }
        if post.didLike {
            post.adjustLikes(addLike: false) { likes in
                cell.likesLabel.text = "\(likes)"
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
            }
        } else {
            post.adjustLikes(addLike: true) { likes in
                cell.likesLabel.text = "\(likes)"
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_selected"), for: .normal)
            }
        }
    }

    func handleCommentTapped(for cell: MainCell) {
        guard let postId = cell.post?.postId else { return }
        Database.fetchPost(with: postId) { post in
            Database.fetchComments(forPost: postId) { comments in
                let detailVC = DetailVC(postId: postId)
                detailVC.post = post
                detailVC.comments = comments
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }

    // MARK: - 기능 탐색, 구성 / 로그인 기능 탐색하고 로그아웃하려고
    func configureLogoutButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        self.navigationItem.title = "커뮤니티"
    }
    
    @objc func handleRefresh() {
        posts.removeAll(keepingCapacity: false)
        self.currentKey = nil
        fetchPost()
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }

    @objc func handleLogout() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                let loginVC = LoginVC()
                let navController = UINavigationController(rootViewController: loginVC)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
                print("로그아웃 성공")
            } catch {
                print("로그아웃 실패")
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - API

    func fetchPost() {
    POSTS_REF.observe(.childAdded) { [weak self] (snapshot) in
        guard let self = self else { return }
        let postId = snapshot.key

        Database.fetchPost(with: postId) { post in
            Database.fetchUser(with: post.ownerUid) { user in
                post.user = user
                self.posts.append(post)
                self.posts.sort { $0.creationDate > $1.creationDate }

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = posts[indexPath.row]
        guard let postId = selectedPost.postId else { return }

        Database.fetchPost(with: postId) { post in
            Database.fetchComments(forPost: postId) { comments in
                let detailVC = DetailVC(postId: postId)
                detailVC.post = post
                detailVC.comments = comments
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
}


