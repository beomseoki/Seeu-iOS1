//
//  DetailContentView.swift
//  seeu
//
//  Created by 김범석 on 2024/03/13.
//

import Foundation
import UIKit
import Firebase

final class DetailContentView: UITableViewHeaderFooterView {

    
    var post: Post? {
        didSet {
            // post 변수가 설정되었을 때 실행되는 코드
            // 해당 게시물 정보를 이용하여 UI 업데이트
            updateUI()
        }
    }
    
//    var post: Post? {
//
//        didSet {
//
//            guard let ownerUid = post?.ownerUid else { return }
//            guard let likes = post?.likes else { return }
//
//            Database.fetchUser(with: ownerUid) { (user) in
//
//                self.profileImageView.loadImage(with: user.profileImageUrl)
//                self.userName.text = user.name
//                self.titleLabel.text = self.post?.caption
//
//
//            }
//
//            likesLabel.text = "\(likes)"
//
//        }
//
//
//    }
    
    static let headerViewID = "DetailContentView"
    
    let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.layer.cornerRadius = 30 / 2
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    let userName: UILabel = {
        let label = UILabel()
        label.text = "범석"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘은 강의에 대해서 설명해줄게 "
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "2d"
        label.textColor = UIColor(w: 166)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    // 좋아요 , 댓글
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setImage(UIImage(systemName: "like_unselected"), for: .normal)
        button.tintColor = .black
        
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "like_unselected")
        button.configuration = config
        //button.addTarget(self, action: #selector(handleLikeTapped) , for: .touchUpInside)

        
        return button
        
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill

        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "comment")
        button.configuration = config
        //button.addTarget(self, action: #selector(handleCommentTapped) , for: .touchUpInside)
        return button
        
    }()
    
    let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // 좋아요 숫자 , 댓글 숫자
    let likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "3"
        
        // 좋아요 버튼을 누른 후 숫자 변경을 위한 코드
        //let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleShowLikes))
        //likeTap.numberOfTapsRequired = 1
        //label.isUserInteractionEnabled = true
        //label.addGestureRecognizer(likeTap)
        return label
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "2"
        
        return label
    }()
    
    
    // 구분선
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(w: 237)
        return view
        
        
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.backgroundView = UIView()
        self.backgroundView?.backgroundColor = .white
        
        // addview
        //subView()
        
        // 레이아웃 설정 
        designView()
        
        // 좋아요, 댓글 버튼과 숫자
        setupHeaderView()
        
        // 레이아웃 설정
        //configureLayout()
        

        
        
            
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func subView() {
//        self.addSubview(self.profileImageView)
//        self.addSubview(self.userName)
//        self.addSubview(self.timeLabel)
//        self.addSubview(self.titleLabel)
//        self.addSubview(self.separator)
//    }
    
//    func configureLayout() {
//        self.profileImageView.translatesAutoresizingMaskIntoConstraints = false
//        self.userName.translatesAutoresizingMaskIntoConstraints = false
//        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.separator.translatesAutoresizingMaskIntoConstraints = false
//
//
//
//        NSLayoutConstraint.activate([
//            self.profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10), // x
//            self.profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
//            self.profileImageView.widthAnchor.constraint(equalToConstant: 40),
//            self.profileImageView.heightAnchor.constraint(equalToConstant: 40),
//
//
//            self.userName.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
//            self.userName.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 8),
//
//            self.timeLabel.topAnchor.constraint(equalTo: self.userName.bottomAnchor, constant: 0),
//            self.timeLabel.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 8),
//
//            self.titleLabel.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: 6), // x
//            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
//            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
//            self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -44), // x
//
//            self.separator.heightAnchor.constraint(equalToConstant: 1),
//            self.separator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
//            self.separator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
//            self.separator.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
//
//
//        ])
//
//    }
    
    
    // post가 설정될 때 UI를 업데이트하는 메서드
    private func updateUI() {
        guard let post = post else { return }
        
        // 사용자 이름 업데이트
        userName.text = post.user?.name
        
        // 프로필 이미지 업데이트
        if let profileImageUrl = post.user?.profileImageUrl {
            profileImageView.loadImage(with: profileImageUrl)
        }
        
        // 게시글 제목 업데이트
        titleLabel.text = post.caption
        
        // 좋아요 수 업데이트
        likesLabel.text = "\(post.likes ?? 0)"
        
        // 댓글 수 업데이트
        if let commentsCount = post.comments?.count {
                commentLabel.text = "\(commentsCount)"
            }
        
        
        
        
        // 다른 UI 업데이트 작업들을 수행할 수 있음
    }
    
    func designView() {
        
        self.addSubview(self.profileImageView)
        self.addSubview(self.userName)
        self.addSubview(self.timeLabel)
        self.addSubview(self.titleLabel)
        self.addSubview(self.separator)
        

        
        
        self.profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 24, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        self.userName.anchor(top: self.topAnchor, left: self.profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        self.timeLabel.anchor(top: self.userName.bottomAnchor, left: self.profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        self.titleLabel.anchor(top: self.profileImageView.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: -40, paddingLeft: 24, paddingBottom: 0, paddingRight: -24, width: 0, height: 0)
        self.separator.anchor(top: nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: -10, paddingRight: -8, width: 0, height: 1)


    }
    
    
    func setupHeaderView() {
        horizontalStackView.addArrangedSubview(likeButton)
        horizontalStackView.addArrangedSubview(commentButton)
        
//        addSubview(horizontalStackView)
//        horizontalStackView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 15)
//
//        addSubview(likesLabel)
//        likesLabel.anchor(top: titleLabel.bottomAnchor, left: likeButton.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: -5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//
//        addSubview(commentLabel)
//        commentLabel.anchor(top: titleLabel.bottomAnchor, left: commentButton.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: -5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(horizontalStackView)
        horizontalStackView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: -30, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 15)
        
        addSubview(likesLabel)
        likesLabel.anchor(top: titleLabel.bottomAnchor, left: likeButton.rightAnchor, bottom: nil, right: nil, paddingTop: -30, paddingLeft: -5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(commentLabel)
        commentLabel.anchor(top: titleLabel.bottomAnchor, left: commentButton.rightAnchor, bottom: nil, right: nil, paddingTop: -30, paddingLeft: -5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    
    
}

