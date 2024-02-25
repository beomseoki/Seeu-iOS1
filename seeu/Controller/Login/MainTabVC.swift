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
        
        //self.tabBarController?.delegate = self



        //밑에 이제 만들어놓은 탭바들을 불러오는 함수
        configureViewControllers()

        //* 사용자가 로그인을 했는지, 안했는지 확인하는 함수
        checkIfUserIsLoggedIn()
    }
    

    
    
    
    func configureViewControllers() {
        
        let HomeFeed = constructNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: HomeFeed())
        
        let uploadPostVC = constructNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"), rootViewController: UploadPostVC())
        
        
        // notification controller
        //let notificationVC = constructNavController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: NotificationsVC())
        
        // profile controller
        let userProfileVC = constructNavController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout()))

        
        viewControllers = [HomeFeed, uploadPostVC, userProfileVC]
        
        // tab bar tint color
        tabBar.tintColor = .black
    }
    
    
    
    
    // 위에 네비게이션 화면 넘기는 거 같은데 , 이거는 이제 우리가 탭바를 선택할 때 그 선택된 이미지들을 갖게 해주는 함수
//    let image = UIImage()
    
    
    func constructNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        // construct nav controller
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.tintColor = .black
        
        // return nav controller
        return navController
    }
    
    
    // MARK: - 탭바 선택지
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = tabBarController.viewControllers?.firstIndex(of: viewController)
        
        if index == 1 { // 탭바 순서 변경해야함
            
//            let navigationController = UINavigationController()
//            let uploadPostVC = UploadPostVC()
//            navigationController.pushViewController(uploadPostVC, animated: true)
//            window?.rootViewController = navigationController
//            window?.makeKeyAndVisible()
            
            
            
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
                let navController = UINavigationController(rootViewController: loginVC) // 로그인 네비게이션으로 변경해주는거임,  그리고 이렇게 해줬으니깐 로그인 화면이랑 연결돼어서 안되면 일로 다시 넘어가는거임
                // 그 다음에 네비게이션으로 변경 해줬으니깐 이제 보내줘야지
                
                navController.modalPresentationStyle = .fullScreen
                
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
    }
    
    
    
}
