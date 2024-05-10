//
//  DetailCell.swift
//  seeu
//
//  Created by 김범석 on 2024/03/01.
//


import UIKit
import RxSwift
import RxCocoa

class DetailCell: UITableViewCell {
    
    // RxSwift Observable로 변경
    var comment: BehaviorSubject<Comment?> = BehaviorSubject(value: nil)
    private var disposeBag = DisposeBag()
    
    // UI 요소
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let commentTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let dataLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(w: 237)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.layer.cornerRadius = 20
        
        addSubview(userNameLabel) // 새로운 UILabel을 추가
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 14).isActive = true
        userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        
        addSubview(commentTextLabel)
        commentTextLabel.translatesAutoresizingMaskIntoConstraints = false
        commentTextLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 4).isActive = true
        commentTextLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15).isActive = true
        commentTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        //commentTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        addSubview(dataLabel)
        dataLabel.translatesAutoresizingMaskIntoConstraints = false
        dataLabel.topAnchor.constraint(equalTo: commentTextLabel.bottomAnchor, constant: 6).isActive = true
        dataLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15).isActive = true
        dataLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        //dataLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.topAnchor.constraint(equalTo: dataLabel.bottomAnchor, constant: 8).isActive = true
        separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        separator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    private func bindUI() {
        // comment Observable을 구독하여 UI 업데이트
        comment.asObservable()
            .subscribe(onNext: { [weak self] comment in
                guard let comment = comment else { return }
                guard let user = comment.user else { return }
                
                let profileImageUrl = user.profileImageUrl ?? ""
                self?.profileImageView.loadImage(with: profileImageUrl)
                
                self?.userNameLabel.text = user.name // 사용자 이름 표시
                
                self?.commentTextLabel.text = comment.commentText
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy.MM.dd. HH:mm"
                let dateString = dateFormatter.string(from: comment.creationDate)
                self?.dataLabel.text = dateString
            })
            .disposed(by: disposeBag)
    }
}
