//
//  Protocols.swift
//  seeu
//
//  Created by 김범석 on 2024/02/26.
//

import Foundation


protocol MainCellDelegate {
    func handleUsernameTapped(for cell: MainCell)
    func handleLikeTapped(for cell: MainCell)
    func handleCommentTapped(for cell: MainCell)
}
