//
//  MainCell.swift
//  seeu
//
//  Created by 김범석 on 2024/02/15.
//

import Foundation
import UIKit
import Firebase

class MainCell: UITableViewCell {
    
    var stackView : UIStackView!
    var post: Post? {
        
        didSet {
            
            guard let ownerUid = post?.ownerUid else { return }
            guard let likes = post?.likes else { return }
            
            Database.fetchUser(with: ownerUid) { (user) in
                
                self.profileImageView.loadImage(with: user.profileImageUrl)
                self.nicknameLabel.text = user.name
                self.titleLabel.text = self.post?.caption
                
                
            }
            
            likesLabel.text = "\(likes)"
            
        }
        
        
    }
    
    let profileImageView: UIImageView = {
       let imageView = UIImageView()
        //imageView.image = UIImage(named: "gear")
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    

    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = UIColor(w: 41)
        label.text = "사용자" //데이터 베이스를 통해서 가져오기
        label.numberOfLines = 1
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(w: 166)
        label.textAlignment = .right
        label.text = "27분 전"
        label.numberOfLines = 1
        return label
    }()
    
    let nicknameContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(w: 68)
        label.textAlignment = .left
        label.text = "아 공부 어떻게 해야해 ?"
        label.numberOfLines = 0
        return label
    }()
    
    
    
    
    // 좋아요 댓글 버튼 스택뷰로 묶은 용도의 함수
    let container: UIStackView = {
        let stackView = UIStackView()
        //stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 6
        return stackView
        
    }()
    
    // 좋아요 , 댓글
    let reation = Reaction()
    
    // 좋아요 , 댓글
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "like_unselected"), for: .normal)
        button.tintColor = .black
        
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        //button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        
        var config = UIButton.Configuration.plain()
        //config.image = UIImage(named: "heart")
        config.image = UIImage(named: "like_unselected")
        //preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 30) 사진 사이즈 변경
        
        //config.imagePadding = 5
        //config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 32, bottom: 8, trailing: 3)
        // leading 에 값을 줘서 왼쪽에서 멀어지게 만들어서 오른쪽 벽 과 붙이게 함
        
        //config.titleAlignment = .leading
        //config.background.strokeColor = UIColor.black 테두리 색깔 지정

        button.configuration = config
        
        return button
        
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "comment"), for: .normal)
        button.tintColor = .black
        
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        //button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        
        var config = UIButton.Configuration.plain()
        //config.image = UIImage(named: "heart")
        config.image = UIImage(named: "comment")
        //preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 30) 사진 사이즈 변경
        
        //config.imagePadding = 5
        //config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 32, bottom: 8, trailing: 3)
        // leading 에 값을 줘서 왼쪽에서 멀어지게 만들어서 오른쪽 벽 과 붙이게 함
        
        //config.titleAlignment = .leading
        //config.background.strokeColor = UIColor.black 테두리 색깔 지정

        button.configuration = config
        return button
        
    }()
    
    // 좋아요 숫자 , 댓글 숫자
    lazy var likesLabel: UILabel = {
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
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "5"
        
        return label
    }()
    
    
    // 구분선
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(w: 237)
        return view
        
        
    }()
    
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .white
        
        
        
        self.contentView.addSubview(self.nicknameContainer)
        
        // 수정 중  , 메인으로 서브뷰를 넣어서 이미지 크기 조절 후 , 닉네임도 맞게 조절함 , 그에 따라서 stackview를 만든 의미가 사라졌기 때문에 수정 해야함
        self.contentView.addSubview(self.profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        self.contentView.addSubview(self.nicknameLabel)
        nicknameLabel.anchor(top: nil, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        nicknameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        
        
        
        // 시간
        //self.contentView.addSubview(self.timeLabel)
        
        
        self.contentView.addSubview(self.titleLabel)
        
        //
        
        // 좋아요 , 댓글 버튼 
        configureActionButtons()
        //self.contentView.addSubview(self.container)
        
        // 좋아요 몇 개 , 댓글 몇 개
        self.contentView.addSubview(self.likesLabel)
        likesLabel.anchor(top: titleLabel.bottomAnchor, left: nil, bottom: nil, right: likeButton.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        self.contentView.addSubview(self.commentLabel)
        commentLabel.anchor(top: titleLabel.bottomAnchor, left: nil, bottom: nil, right: commentButton.rightAnchor, paddingTop: 10, paddingLeft: 3, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        //self.contentView.addSubview(self.reation)
        
        self.contentView.addSubview(self.separator)
        
        
        //self.nicknameContainer.addArrangedSubview(self.profileImageView)
        //self.nicknameContainer.addArrangedSubview(self.nicknameLabel)
        self.nicknameContainer.addArrangedSubview(self.timeLabel)
        
        
        // 좋아요 댓글 스택 뷰
        //self.container.addArrangedSubview(self.likeButton)
        ///self.container.addArrangedSubview(self.commentButton)
        //self.container.addArrangedSubview(self.likesLabel)
        
        
        
        
        // 레이아웃 설정
        self.nicknameContainer.translatesAutoresizingMaskIntoConstraints = false
        
        //self.container.translatesAutoresizingMaskIntoConstraints = false
        
        self.profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        //수정중
        self.nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        //시간
        //self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //self.reation.translatesAutoresizingMaskIntoConstraints = false
        
        //self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.separator.translatesAutoresizingMaskIntoConstraints = false

        
        //Layout 조절하기 , x
        
        NSLayoutConstraint.activate([
//            self.nicknameContainer.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
//            self.nicknameContainer.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24),
            
            // 수정중
            self.nicknameContainer.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            self.nicknameContainer.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 24),
            self.nicknameContainer.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24),
            self.nicknameContainer.heightAnchor.constraint(equalToConstant: 24),
            
            
            //self.profileImageView.widthAnchor.constraint(equalToConstant: 24),
            //self.profileImageView.heightAnchor.constraint(equalToConstant: 24),
            
            //self.timeLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            //self.timeLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 24),
            //self.timeLabel.heightAnchor.constraint(equalToConstant: 24),
            
            
            //수정중
            
            
            // 게시글 내용
            //self.titleLabel.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: 8),
            self.titleLabel.topAnchor.constraint(equalTo: self.nicknameContainer.bottomAnchor, constant: 20),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -24),
            

            // 좋아요 , 댓글 수정 전
            //self.container.heightAnchor.constraint(equalToConstant: 16),
            //self.container.bottomAnchor.constraint(equalTo: self.separator.topAnchor, constant: 5),
            //self.container.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 10),
            
            //self.reation.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 5),
            //self.reation.heightAnchor.constraint(equalToConstant: 16),
            //self.reation.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 10),
            //self.reation.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -6),
            
            self.separator.heightAnchor.constraint(equalToConstant: 1),
            //self.separator.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 5),
            self.separator.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            self.separator.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            self.separator.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 5)


        
        ])
        
    }
    
    func configurePostCaption(user: User) {
        
        //guard let post = self.post else { return }
        //guard let caption = post.caption else { return }
        //guard let username = post.user?.name else { return }
        
        
        //let customType =
        
        
        
        
        
    }
    
    
    // 새로 만든 버튼 함수
    func configureActionButtons() {
        stackView = UIStackView(arrangedSubviews: [likeButton, commentButton])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        //stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(stackView)
        stackView.anchor(top: titleLabel.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 16)
        
        
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
