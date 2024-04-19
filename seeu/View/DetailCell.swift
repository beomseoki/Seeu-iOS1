//
//  DetailCell.swift
//  seeu
//
//  Created by 김범석 on 2024/03/01.
//

import Foundation
import UIKit


class DetailCell: UITableViewCell {
    
    var comment: Comment? {
        
        didSet {
            
            guard let user = comment?.user else { return }
            guard let profileImageUrl = user.profileImageUrl else { return }
            guard let commentText = comment?.commentText else { return }
            guard let username = user.name else { return }
            
            profileImageView.loadImage(with: profileImageUrl)
            
            let attributedText = NSMutableAttributedString(string: username, attributes: [NSMutableAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: " \(commentText)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
            attributedText.append(NSAttributedString(string: " 2d.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            

            
            commnetTextLabel.attributedText = attributedText
    
            
        }
    }
    
    let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()

    
    let commnetTextLabel: UITextView = {
        let tv = UITextView()
        tv.textContainer.maximumNumberOfLines = 4
        tv.textContainer.lineBreakMode = .byWordWrapping
        tv.font = UIFont.systemFont(ofSize: 12)
        tv.isScrollEnabled = false
        return tv
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(self.profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 14, paddingBottom: 0, paddingRight: 0, width: 40, height: 40) // top 10 에서 조정중
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 40 / 2
        
        
        addSubview(commnetTextLabel)
        commnetTextLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 14, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)
        commnetTextLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
//        addSubview(separatorView)
//        separatorView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 60, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


