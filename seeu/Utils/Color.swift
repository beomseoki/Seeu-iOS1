//
//  Color.swift
//  seeu
//
//  Created by 김범석 on 2024/02/15.
//

import UIKit

extension UIColor {
    convenience init(r: Int, g:Int, b:Int, a: Int) {
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: CGFloat(a)/255)
    }
    
    convenience init(r: Int, g:Int, b:Int) {
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1)
    }
    
    
    convenience init(w: Int) { // 같은 숫자의 색깔을 표현할때 간단하게 표현가능 
        self.init(white: CGFloat(w)/255, alpha: 1)
    }
}
