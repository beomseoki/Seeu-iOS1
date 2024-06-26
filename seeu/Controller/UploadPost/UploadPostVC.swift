//
//  UploadPostVC.swift
//  seeu
//
//  Created by 김범석 on 2024/01/22.
//

import UIKit
import Firebase

class UploadPostVC: UIViewController, UITextViewDelegate {

    // MARK: - 선언
    
    let textViewPlaceHolder = "텍스트를 입력하세요"
    
    let captionTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = UIColor.white
        tv.font = UIFont.systemFont(ofSize: 20)
        return tv
    }()
    
    let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.setTitle("게시하기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleSharePost), for: .touchUpInside)
        return button
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        captionTextView.delegate = self

        navigationController?.navigationBar.topItem?.title = "글쓰기"
        captionTextView.text = "텍스트를 입력하세요"
        captionTextView.textColor = UIColor.lightGray
        
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 200) // 100
        captionTextView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        view.addSubview(shareButton)
        shareButton.anchor(top: captionTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 12, paddingBottom: 0, paddingRight: 24, width: 0, height: 40)
        
        // 네비게이션 버튼 취소, 게시
        configureNavigationButtons()
        
        

    }
    
    // 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
        }
    
    // MARK: - UiTextView delegate
    
    func textViewDidChange(_ textView: UITextView) {
    
        guard !textView.text.isEmpty else { // 비어있는경우
            shareButton.isEnabled = false
            shareButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            return
        }
        
        shareButton.isEnabled = true
        shareButton.backgroundColor = UIColor(red: 135/255, green: 190/223, blue: 223/255, alpha: 1)
    
        }
    

    // 데이터를 통해 게시하는거임
    @objc func handleSharePost() {
            guard
                let caption = captionTextView.text,
                let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // 현재 시간을 가져오기
        let creationDate = Int(NSDate().timeIntervalSince1970)

        
        // 게시물 데이터 정의
        let values = ["caption": caption,
                      "creationDate": creationDate,
                      "likes": 0,
                      "ownerUid": currentUid] as [String: Any]
        
        // 게시글 아이디
        let postId = POSTS_REF.childByAutoId()
        
        // 게시글 아이디를 통해서 업로드를 하면 , 그거에 대해서 정보들이 업로드 되면 피드로 돌아가기
        postId.updateChildValues(values) { err, ref in
            
            // 유저 프로필 업뎃용
            guard let postKey = postId.key else { return }
            USER_POSTS_REF.child(currentUid).updateChildValues([postKey: 1])

            // 값들을 가지고 제대로 되면 이제 다시 홈 피드
            self.dismiss(animated: true) {
                self.tabBarController?.selectedIndex = 0
            }
            
        }

    }
    
    
    // MARK: - Handler부분
    
    @objc func handleCancel() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func configureNavigationButtons() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(handleCancel))
        
        
    }
    
    
    
    // MARK: - 내용 안내
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if captionTextView.text.isEmpty {
            captionTextView.text = "텍스트를 입력하세요"
            captionTextView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if captionTextView.textColor == UIColor.lightGray {
            captionTextView.text = nil
            captionTextView.textColor = UIColor.black
        }
    }

}
