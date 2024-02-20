//
//  Reaction.swift
//  seeu
//
//  Created by 김범석 on 2024/02/16.
//

import Foundation
import UIKit


class Reaction: UIStackView {
    
    
    
    
    let likebutton: UIButton = {
        let button = UIButton()

        // text
        button.setTitle("0", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(UIColor(r: 89, g: 177, b: 187), for: .normal)

        // image
        //button.setImage(UIImage(named: "heart"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        
        var config = UIButton.Configuration.plain()
        //config.image = UIImage(named: "heart")
        config.image = UIImage(named: "like_unselected")
        //preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 30) 사진 사이즈 변경
        
        config.imagePadding = 5
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 32, bottom: 8, trailing: 3)
        // leading 에 값을 줘서 왼쪽에서 멀어지게 만들어서 오른쪽 벽 과 붙이게 함 
        
        //config.titleAlignment = .leading
        //config.background.strokeColor = UIColor.black 테두리 색깔 지정

        button.configuration = config
        
        return button



    }()
    
    let commentbutton: UIButton = {
        let button = UIButton()
        button.setTitle("3", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(UIColor(r: 1, g: 1, b: 1), for: .normal)
        

        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "comment")
        config.imagePadding = 5
        
        //config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20)

        config.titleAlignment = .leading

        button.configuration = config
        
        

        return button
        
        
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.spacing = 6
        self.axis = .horizontal
        self.addArrangedSubview(self.likebutton)
        self.addArrangedSubview(self.commentbutton)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
}
