//
//  DetailVC.swift
//  seeu
//
//  Created by 김범석 on 2024/03/01.
//

import Foundation
import Firebase
import UIKit


class DetailVC: UIViewController {
    
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)

    var posts = [Post]()
    var comments = [Comment]()
    var postId: String?
    
    
    //수정중
    var post: Post? // post 멤버 추가 
    
    
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)

        containerView.addSubview(postButton)
        postButton.anchor(top: nil, left: nil, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 50, height: 0)
        postButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        
        containerView.addSubview(commentTextField)
        commentTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: postButton.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        
        
        // 구분선
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        containerView.addSubview(separatorView)
        separatorView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        containerView.backgroundColor = .white
        
        return containerView
    }()


    

    

    
    
    lazy var commentTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "댓글을 남겨보세요"
        tf.font = UIFont.systemFont(ofSize: 14)
        
        //tf.layer.cornerRadius = 14.0
        //tf.layer.borderWidth = 1
        //tf.layer.borderColor = UIColor.gray.cgColor
        
        return tf
    }()
    
    let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("게시", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleUploadComment), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DetailCell.self, forCellReuseIdentifier: "DetailCell")
        tableView.register(DetailContentView.self, forHeaderFooterViewReuseIdentifier: "DetailContentView")
        //tableView.sectionFooterHeight = 0
        tableView.sectionHeaderHeight = UITableView.automaticDimension // 1

        navigationItem.title = "Comments"
        
        // 댓글 업데이트
        //fetchComments()
        
        
        //x
//        if let selectedPost = post {
//            // 선택된 게시물의 내용 표시
//            print("Selected post capion: \(selectedPost.caption)")
//            print("Selected post likes: \(selectedPost.likes)")
//
//        }
        
        // 게시글 업데이트
        //fetchPost()
        
        // 레이아웃 설정
        adjust()
        
        //setup()
        
        // 댓글 기능 수정
        fetchData()
        

    }
    
    
    // 화면 클릭시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
        


    
    // 상세페이지에 들어갔을 때 탭바를 없애고, 다시 나왔을 때 나타날 수 있게 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // 키보드 구현!
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
        
    
    func adjust() {
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        
        ])
        
        
        tableView.separatorStyle = .none
        tableView.reloadData()
        tableView.layoutIfNeeded()
        
        
    }
    
    @objc func handleUploadComment() {
        print("Upload button tapped") // 버튼이 눌렸는지 확인하기 위한 출력
        guard let postId = self.postId else {
            print("postId is nil") // postId가 nil인 경우를 확인하기 위한 출력
            return
        }
        guard let commentText = commentTextField.text else {
            print("Comment text is nil") // 댓글 텍스트가 nil인 경우를 확인하기 위한 출력
            return
        }
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Current user's UID is nil") // 현재 사용자의 UID가 nil인 경우를 확인하기 위한 출력
            return
        }
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        // 값을 통해서 내가 작성한 댓글, 아이디 , 날짜등을 업데이트 함
        let values = ["commentText": commentText,
                      "uid": uid,
                      "creationDate": creationDate] as [String : Any]
        
        COMENT_REF.child(postId).childByAutoId().updateChildValues(values) { err, ref in
            if let error = err {
                print("Error uploading comment:", error.localizedDescription) // 업로드 과정에서 발생한 오류를 출력하여 확인
            } else {
                print("Comment uploaded successfully") // 댓글이 성공적으로 업로드되었는지 확인
                self.commentTextField.text = nil // 게시를 한 후 텍스트를 빈칸으로 만들기 위해
            }
        }
    }

    
    // MARK: - API 수정중
    
    func fetchData() {
        guard let postId = self.postId else { return }
        
        DispatchQueue.global().async {
            let dispatchGroup = DispatchGroup()
            
            var post: Post?
            var comments: [Comment] = []
            
            dispatchGroup.enter()
            Database.fetchPost(with: postId) { fetchedPost in
                post = fetchedPost
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            Database.fetchComments(forPost: postId) { fetchedComments in
                comments = fetchedComments
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                // 데이터가 준비되면 UI를 업데이트합니다.
                self.post = post
                self.comments = comments
                self.tableView.reloadData()
            }
        }
    }

    
    // 댓글 수정중,  
//    func fetchComments() {
//
//        guard let postId = self.postId else { return }
//
//        // 게시글 아이디를 통해, 댓글에 있는 것들을 하나씩 업데이트 될때마다 업데이트 해주는 observe .childAdded / snapshot에는 comment에 있는 값들이 있기 때문에 그걸 뽑아주고 셀에 넣어줌
//        COMENT_REF.child(postId).observe(.childAdded) { snapshot in
//
//
//            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
//            guard let uid = dictionary["uid"] as? String else { return }
//            print("Fetched comment data:", dictionary) // 댓글 데이터 출력
//
//
//            Database.fetchUser(with: uid) { user in
//                let comment = Comment(user: user, dictionary: dictionary)
//                self.comments.append(comment)
//                self.tableView.reloadData()
//            }
//
//
//        }
//    }
    
//    func fetchComments() {
//        guard let postId = self.postId else { return }
//
//        COMENT_REF.child(postId).observe(.childAdded) { snapshot in
//            guard let dictionary = snapshot.value as? [String: Any] else { return } // 변경된 부분
//            print("Fetched comment data:", dictionary) // 댓글 데이터 출력
//
//            Database.fetchUser(with: dictionary["uid"] as? String ?? "") { user in
//                let comment = Comment(user: user, dictionary: dictionary)
//                self.comments.append(comment)
//                self.tableView.reloadData()
//            }
//        }
//    }


        
        
    }
    



    // 사용자 게시글
//    func fetchPost() {
//
//        POSTS_REF.observe(.childAdded) { (snapshot) in
//
//            let postId = snapshot.key
//
//
//            Database.fetchPost(with: postId) { post in
//
//                self.posts.append(post)
//
//                self.posts.sort { post1, post2 in
//                    return post1.creationDate > post2.creationDate
//                }
//
//
//                self.tableView.reloadData()
//            }
//        }
//
//    }
//

    
//    private func viewLayout() {
//        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
//    }
    
    
    




extension DetailVC: UITableViewDataSource, UITableViewDelegate {


    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell") as! DetailCell
        _ = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 500)) // 수정중
        cell.backgroundColor = .red
        cell.comment = comments[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DetailContentView") as! DetailContentView

        view.post = post
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
        
    }
    

    
    
    
    
}



