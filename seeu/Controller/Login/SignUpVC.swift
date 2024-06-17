//
//  SignUpVC.swift
//  Watch
//
//  Created by 김범석 on 2024/01/16.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageSelected = false
    var isSigningUp = false
    var isUploadingImage = false
    
    let plusPhotoBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSelectProFilePhoto), for: .touchUpInside)
        return button
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "이름"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(forValidation), for: .editingChanged)
        return tf
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "아이디"
        tf.textContentType = .username
        tf.keyboardType = .emailAddress
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(forValidation), for: .editingChanged)
        return tf
    }()
    
    let passWordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "비밀번호"
        tf.textContentType = .password
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(forValidation), for: .editingChanged)
        return tf
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    let alreadyAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "계정을 가지고 있나요?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "로그인", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)]))
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(plusPhotoBtn)
        plusPhotoBtn.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 35, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        plusPhotoBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        configureViewComponents()
        view.addSubview(alreadyAccountButton)
        alreadyAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 100, paddingRight: 0, width: 0, height: 50) // paddingbottom 0
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
        }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 선택된 이미지를 가져옴
        guard let profileImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            imageSelected = false // 이미지가 선택되지 않았다면 flag를 false로 설정
            return
        }
        
        imageSelected = true // 이미지가 선택되었다면 flag를 true로 설정
        
        // 선택된 이미지로 버튼의 이미지를 설정
        plusPhotoBtn.layer.cornerRadius = plusPhotoBtn.frame.width / 2
        plusPhotoBtn.layer.masksToBounds = true
        plusPhotoBtn.layer.borderColor = UIColor.black.cgColor
        plusPhotoBtn.layer.borderWidth = 2
        plusPhotoBtn.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        // 이미지 업로드 함수 호출
        uploadProfileImage(profileImage) { profileImageURL in

        }

        // 이미지 피커 컨트롤러 닫기
        self.dismiss(animated: true, completion: nil)
    }
    
    // 이미지 업로드를 담당하는 함수
    func uploadProfileImage(_ image: UIImage, completion: @escaping (String) -> Void) {
        guard !isUploadingImage else {
            print("이미 업로드 중입니다.")
            return
        }
        isUploadingImage = true
        
        let filename = NSUUID().uuidString // 고유 파일명 생성
        let storageRef = Storage.storage().reference().child("profile_images").child(filename)
        guard let uploadData = image.jpegData(compressionQuality: 0.3) else {
            isUploadingImage = false
            return
        }
        
        // Firebase Storage에 이미지 업로드
        storageRef.putData(uploadData, metadata: nil) { metadata, error in
            self.isUploadingImage = false
            if let error = error {
                print("이미지 업로드 실패: \(error.localizedDescription)")
                return
            }
            
            // 업로드된 이미지의 URL 가져오기
            storageRef.downloadURL { (downloadURL, error) in
                if let error = error {
                    print("다운로드 URL 가져오기 실패: \(error.localizedDescription)")
                    return
                }
                
                guard let profileImageURL = downloadURL?.absoluteString else { return }
                print("이미지가 성공적으로 업로드되었습니다: \(profileImageURL)")
                // 업로드된 이미지의 URL을 completion handler를 통해 전달
                completion(profileImageURL)
            }
        }
    }

   
    
    
    
    @objc func handleShowLogin() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignUp() {
        guard !isSigningUp else { return }
        isSigningUp = true
        
        guard let email = emailTextField.text, let password = passWordTextField.text, let name = nameTextField.text else {
            isSigningUp = false
            return
        }

        
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            self.isSigningUp = false
            if let error = error {
                print("Failed to create account: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "회원가입 실패", message: "회원정보를 다시한번 입력해주세요.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            if let profileImage = self.plusPhotoBtn.imageView?.image {
                        self.uploadProfileImage(profileImage) { profileImageURL in
                            let newUser = ["name": name,
                                           "profileImageUrl": profileImageURL]
                            // Firebase Realtime Database에 사용자 정보 저장
                            USER_REF.child(uid).setValue(newUser) { error, _ in
                                if let error = error {
                                    print("정보저장 실패 : \(error.localizedDescription)")
                                    // 실패한 경우에 대한 처리 추가
                                    return
                                }
                                print("사용자 정보 저장 성공!")
                                DispatchQueue.main.async {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        }
                    } else {
                        // 이미지가 선택되지 않은 경우에 대한 처리 추가
                        print("프로필 이미지가 선택되지 않았습니다.")
                    }
                }
            }
    
    @objc func forValidation() {
        guard emailTextField.hasText, passWordTextField.hasText, nameTextField.hasText, imageSelected == true else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            return
        }
        
        loginButton.isEnabled = true
        loginButton.backgroundColor = UIColor(red: 135/255, green: 200/223, blue: 223/255, alpha: 1)
    }
    
    
    @objc func handleSelectProFilePhoto() {
        
        // 이미지를 가져오기 위해서는 이렇게 delegate를 이용해서 넣어주면 됨
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        // 위에서 가져온 이미지를 이제 넘겨주기위한 present함수!
        DispatchQueue.main.async {
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        
        
    }
    
    func configureViewComponents() {
        let stackView = UIStackView(arrangedSubviews: [nameTextField, emailTextField, passWordTextField, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: plusPhotoBtn.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 240)
    }
}
