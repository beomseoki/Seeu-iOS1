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
    
    let tableView = UITableView(frame: .zero, style: .grouped)

    var comments = [Comment]()
    var postId: String?
    
    
    
    
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

        navigationItem.title = "Comments"
        
        // 댓글 업데이트
        fetchComments()
        
        // 레이아웃 설정
        adjust()
        

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
        
        // 현재 아이디를 기준으로 내가 댓글을 게시했을 때 내용, 아이디, 날짜등을 DB에 저장할 수 있도록
        
        guard let postId = self.postId else { return }
        guard let commentText = commentTextField.text else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        // 값을 통해서 내가 작성한 댓글, 아이디 , 날짜등을 업데이트 함
        let values = ["commentText": commentText,
                      "uid": uid,
                      "creationDate": creationDate] as [String : Any]
        
        COMENT_REF.child(postId).childByAutoId().updateChildValues(values) { err, ref in
            self.commentTextField.text = nil // 게시를 한 후 텍스트를 빈칸으로 만들기 위해 
        }
    }
    
    func fetchComments() {
        
        guard let postId = self.postId else { return }
        
        // 게시글 아이디를 통해, 댓글에 있는 것들을 하나씩 업데이트 될때마다 업데이트 해주는 observe .childAdded / snapshot에는 comment에 있는 값들이 있기 때문에 그걸 뽑아주고 셀에 넣어줌
        COMENT_REF.child(postId).observe(.childAdded) { snapshot in
            
            
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            Database.fetchUser(with: uid) { user in
                let comment = Comment(user: user, dictionary: dictionary)
                self.comments.append(comment)
                self.tableView.reloadData()
            }
            
            
        }
        
        
    }
    
    
    

}


extension DetailVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell") as! DetailCell
        
        cell.comment = comments[indexPath.item]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DetailContentView") as! DetailContentView
        view.backgroundView = UIView()
        view.backgroundView?.backgroundColor = .red
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    // 댓글 게시하기 위한 함수 생성

    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = tableView.dequeueReusableCell(withIdentifier: "DetailContentView") as! DetailContentView
//        view.backgroundView = UIView()
//        view.backgroundColor = .red
//        return view
//        
//    }
    
    
    
    
    
}



