//
//  LoginVCViewController.swift
//  Watch
//
//  Created by 김범석 on 2024/01/14.
//

import UIKit
import Firebase



    
class LoginVC: UIViewController {
    
    let logoContainerView: UIView = {
        let view = UIView()
        //let logoImageView = UIImageView(image: #imageLiteral(resourceName: "logo_white")) //여기에 이미지 넣어서 이쁘게 가능 #imageliteral()을 이용하면 됨
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "coconut . (2)"))
        logoImageView.contentMode = .scaleAspectFill
        view.addSubview(logoImageView)
        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        //view.backgroundColor = UIColor(red: 0/255, green: 120/255, blue: 175/255, alpha: 1)
        view.backgroundColor = UIColor(red: 98/255, green: 206/255, blue: 203/255, alpha: 1)
        return view
    }()
    
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "이메일"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        //tf.frame.size.height = 48
        tf.layer.cornerRadius = 5
        tf.clipsToBounds = true
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(forValidation), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "비밀번호"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        //tf.frame.size.height = 48
        tf.layer.cornerRadius = 10
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(forValidation), for: .editingChanged)
        return tf
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        //button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.backgroundColor = UIColor(red: 130/255, green: 210/255, blue: 205/255, alpha: 1)
        button.isEnabled = false // 처음부터 적용안된다고 먼저 말해놔야지
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "계정을 가지고 있지 않으신가요?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "회원가입", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor:  UIColor(red: 0/255, green: 0/223, blue: 0/255, alpha: 1)]))
        //UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        button.setAttributedTitle(attributedTitle, for: .normal)
        //사이즈 14
        
        
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //background color
        view.backgroundColor = .white
        // 내비게이션 위에 막대 없애기
        
        navigationController?.navigationBar.isHidden = true
        
        navigationController?.navigationBar.barStyle = .black
        
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 140)
        
        configureViewComponents()
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 480, paddingRight: 0, width: 0, height: 50) // 50

        
        
        
        
    }

    // MARK: - 로그인 쪽
    

    @objc func handleShowSignUp() {
        let signUpVC = SignUpVC()
        navigationController?.pushViewController(signUpVC, animated: true)
        
    }
    
    @objc func handleLogin() {
        
        // 로그인 하기위한 이메일,비밀번호를 가져와야함 ! 로그인 버튼 눌러서 이제 데베에 있는 정보랑 비교를 해야하니깐
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        
        
        // 이메일과 이제 비번을 가져와서 서명할 수 있게 !
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            
            
            // 가져오는데 에러가 뜨는경우
            if let error = error {
                print("해당 계정에 로그인 할 수 없습니다." , error.localizedDescription)
                let alertController = UIAlertController(title: "로그인 실패", message: "이메일과 비밀번호가 올바르지 않습니다.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            // 이메일 , 비번을 가져오는데 성공한 경우
            print("성공적으로 로그인 됨 ")
            let mainTabVC = MainTabVC()
            mainTabVC.modalPresentationStyle = .fullScreen
            self.present(mainTabVC, animated: true, completion: nil)
            
        
            
            
            
        }
        
        
        
    }
    
    @objc func forValidation() {
        
        // 로그인 하기위해서 이메일, 비밀번호가 텍스트필드에 잘 적혀져있는걸 확인하는거 hastext
        guard
            emailTextField.hasText,
            passwordTextField.hasText else {
                
                // 근데 비어있음, 즉 사용자가 아이디 비번 안적었다는거임
                loginButton.isEnabled = false
                loginButton.backgroundColor = UIColor(red: 130/255, green: 210/255, blue: 205/255, alpha: 1)
                return
                
                
        }
        
        // 근데 비어있지않고 제대로 작성이 되었다면 !
        
        loginButton.isEnabled = true
        loginButton.backgroundColor = UIColor(red: 135/255, green: 200/223, blue: 223/255, alpha: 1)

        
    }
    
    
    func configureViewComponents() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,loginButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = 10

        
        view.addSubview(stackView)
        stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 45, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 180) // 140
        
        
//        view.addSubview(descriptionLabel)     설명창 넣어보는거
//        descriptionLabel.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 50, paddingBottom: 0, paddingRight: 50, width: 0, height: 1000)
        
    }
    

    

}

