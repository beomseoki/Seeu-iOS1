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
    
    var delegate: MainCellDelegate?
    var stackView : UIStackView!
    var post: Post? {
        
        didSet {
            
            guard let ownerUid = post?.ownerUid else { return }
            guard let likes = post?.likes else { return }
            
            Database.fetchUser(with: ownerUid) { (user) in
                self.titleLabel.text = self.post?.caption
                
                
            }
            
            likesLabel.text = "\(likes)"
            
            // 게시물 작성 시간 표시
            if let creationDate = post?.creationDate {
                let timeAgoDisplay = creationDate.timeAgoDisplay()
                timeLabel.text = timeAgoDisplay
            }
            
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
    
    lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Username", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(handleUsernameTapped) , for: .touchUpInside)
        return button
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

    // 좋아요 , 댓글
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setImage(UIImage(systemName: "like_unselected"), for: .normal)
        button.tintColor = .black
        
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        //button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "like_unselected")
        button.configuration = config
        button.addTarget(self, action: #selector(handleLikeTapped) , for: .touchUpInside)

        
        return button
        
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        //button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "comment")
        button.configuration = config
        button.addTarget(self, action: #selector(handleCommentTapped) , for: .touchUpInside)
        return button
        
    }()
    
    // 좋아요 숫자 , 댓글 숫자
    let likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "3"
        return label
    }()
    
    let commentLabel: UILabel = {
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
        
        setupSubviews()
        setupConstraints()
    }

    private func setupSubviews() {
        // 닉네임 컨테이너 설정
        self.contentView.addSubview(self.nicknameContainer)
        
        // 프로필 이미지 설정
        self.contentView.addSubview(self.profileImageView)
        profileImageView.layer.cornerRadius = 20 // 40 / 2
        
        // 유저 이름 버튼 설정
        self.contentView.addSubview(self.usernameButton)
        
        // 타임 라벨을 닉네임 컨테이너에 추가
        self.nicknameContainer.addArrangedSubview(self.timeLabel)

        // 타이틀 라벨 설정
        self.contentView.addSubview(self.titleLabel)
        
        // 좋아요, 댓글 버튼 설정
        configureActionButtons()
        
        // 좋아요 라벨 설정
        self.contentView.addSubview(self.likesLabel)
        
        // 댓글 라벨 설정
        self.contentView.addSubview(self.commentLabel)
        
        // 구분선 설정
        self.contentView.addSubview(self.separator)
        
        // Auto Layout을 위해 TranslatesAutoresizingMaskIntoConstraints를 false로 설정
        self.nicknameContainer.translatesAutoresizingMaskIntoConstraints = false
        self.profileImageView.translatesAutoresizingMaskIntoConstraints = false
        self.usernameButton.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.likesLabel.translatesAutoresizingMaskIntoConstraints = false
        self.commentLabel.translatesAutoresizingMaskIntoConstraints = false
        self.separator.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // 닉네임 컨테이너 레이아웃
            self.nicknameContainer.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            self.nicknameContainer.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 24),
            self.nicknameContainer.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24),
            self.nicknameContainer.heightAnchor.constraint(equalToConstant: 24),
            
            // 프로필 이미지 레이아웃
            self.profileImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            self.profileImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            self.profileImageView.widthAnchor.constraint(equalToConstant: 40),
            self.profileImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // 유저 이름 버튼 레이아웃
            self.usernameButton.centerYAnchor.constraint(equalTo: self.profileImageView.centerYAnchor),
            self.usernameButton.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 8),
            
            // 타이틀 라벨 레이아웃
            self.titleLabel.topAnchor.constraint(equalTo: self.nicknameContainer.bottomAnchor, constant: 20),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -24),
            
            // 좋아요 라벨 레이아웃
            self.likesLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            self.likesLabel.trailingAnchor.constraint(equalTo: self.likeButton.trailingAnchor),
            
            // 댓글 라벨 레이아웃
            self.commentLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            self.commentLabel.trailingAnchor.constraint(equalTo: self.commentButton.trailingAnchor),
            
            // 분리선 레이아웃
            self.separator.heightAnchor.constraint(equalToConstant: 1),
            self.separator.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            self.separator.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            self.separator.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 5)
        ])
    }

    
    // MARK: - Handlers
    
    @objc func handleUsernameTapped() {
        delegate?.handleUsernameTapped(for: self)
    }
    
    @objc func handleLikeTapped() {
        delegate?.handleLikeTapped(for: self)
    }
    
    @objc func handleCommentTapped() {
        delegate?.handleCommentTapped(for: self)
    }
    

    // 댓글 수 없데이트 함수
    func configureCommentCount(commentCount: Int) {
        commentLabel.text = "\(commentCount)"
    }
    
    
    // 새로 만든 버튼 함수
    func configureActionButtons() {
        stackView = UIStackView(arrangedSubviews: [likeButton, commentButton])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        
        
        addSubview(stackView)
        stackView.anchor(top: titleLabel.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 16)
        
        
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
