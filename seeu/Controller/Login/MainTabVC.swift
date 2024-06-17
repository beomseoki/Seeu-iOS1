//
//  MainTabVC.swift
//  seeu
//
//  Created by 김범석 on 2024/01/22.
//

import UIKit
import Firebase

class MainTabVC: UITabBarController, UITabBarControllerDelegate {

   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.delegate = self
        configureViewControllers()
        checkIfUserIsLoggedIn()
    }
    

    
    
    
    func configureViewControllers() {
        
        let HomeFeed = constructNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: HomeFeed())
        
        let uploadPostVC = constructNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"), rootViewController: UploadPostVC())

        let userProfileVC = constructNavController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout()))

        viewControllers = [HomeFeed, uploadPostVC, userProfileVC]

        tabBar.tintColor = .black
    }
    
    
    
    
    // 탭바를 선택할 때 그 선택된 이미지들을 갖게 해주는 함수
    func constructNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {

        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.tintColor = .black

        return navController
    }
    
    
    // MARK: - 탭바 선택지
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = tabBarController.viewControllers?.firstIndex(of: viewController)
        
        if index == 1 { // 탭바 순서 변경
            
            let uploadPostVC = UploadPostVC()
            let nav = UINavigationController(rootViewController: uploadPostVC)
            nav.navigationBar.tintColor = .black
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)

            return false
        }
        
        return true
    }
    

    
    
    
    
    
    // MARK: - 2
    

    //현재 사용자가 로그인이 되어있는지 확인하는 함수
    func checkIfUserIsLoggedIn() {
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                // 현재 사용자가 없으니깐 빠르게 나가게 하는거임
                let loginVC = LoginVC()
                let navController = UINavigationController(rootViewController: loginVC)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
    }
}
