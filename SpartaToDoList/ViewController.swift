//
//  ViewController.swift
//  SpartaToDoList
//
//  Created by t2023-m0064 on 2023/09/18.
//

import Alamofire
import UIKit

class ViewController: UIViewController {
    let toDoListButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ToDoList", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.layer.cornerRadius = 50 / 2
        button.addTarget(self, action: #selector(toDoListButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    let completedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Completed", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.layer.cornerRadius = 50 / 2
        button.addTarget(self, action: #selector(CompletedButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    let profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Profile", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.layer.cornerRadius = 50 / 2
        button.addTarget(self, action: #selector(ProfileButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    func configureButtons() {
        toDoListButton.translatesAutoresizingMaskIntoConstraints = false
        completedButton.translatesAutoresizingMaskIntoConstraints = false
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(toDoListButton)
        view.addSubview(completedButton)
        view.addSubview(profileButton)
        
        NSLayoutConstraint.activate([
            toDoListButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 350),
            toDoListButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            toDoListButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            toDoListButton.heightAnchor.constraint(equalToConstant: 64),
            
            completedButton.topAnchor.constraint(equalTo: toDoListButton.bottomAnchor, constant: 25),
            completedButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            completedButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            completedButton.heightAnchor.constraint(equalToConstant: 64),
            
            profileButton.topAnchor.constraint(equalTo: completedButton.bottomAnchor, constant: 25),
            profileButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            profileButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            profileButton.heightAnchor.constraint(equalToConstant: 64)
        ])
        
//        toDoListButton.addTarget(self, action: #selector(createButtonPressed) , for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "" // 홈 화면의 타이틀 설정
        
        let imageView = UIImageView(frame: CGRect(x: 25, y: 160, width: 340, height: 210))
        let imageURL = "https://spartacodingclub.kr/css/images/scc-og.jpg"
        AF.request(imageURL)
            .response { response in
                switch response.result {
                case .success(let data):
                    DispatchQueue.main.async {
                        imageView.image = UIImage(data: data!)
                        self.view.addSubview(imageView) // Add imageView to the view hierarchy after image is loaded
                    }
                case .failure:
                    print("error")
                }
            }
        
        configureButtons()
    }
    
////     스토리 보드를 이용한 화면전환
//    @objc func toDoListButtonDidTap() {
//        let toDoListPage = UIStoryboard(name: "ToDoListPage", bundle: nil)
//        guard let toDoListPageViewController = toDoListPage.instantiateViewController(withIdentifier: "ToDoListPage") as? ToDoListPageViewController else { return }
//
//        toDoListPageViewController.modalPresentationStyle = .fullScreen
//        show(toDoListPageViewController, sender: nil)
//    }
    
//     코드만으로 화면전환
    @objc func toDoListButtonDidTap() {
           // ToDoListPageViewController 대신 해당 페이지의 루트 뷰 컨트롤러로 감싸진 내비게이션 컨트롤러를 만듭니다.
           let toDoListViewController = ToDoListPageViewController() // ToDoListPageViewController의 인스턴스 생성
        self.navigationController?.pushViewController(toDoListViewController, animated: true)
       }
    
    
//    @objc func toDoListButtonDidTap() {
//        // ToDoListPageViewController 대신 해당 페이지의 루트 뷰 컨트롤러로 감싸진 내비게이션 컨트롤러를 만듭니다.
//        let toDoListViewController = ToDoListPageViewController() // ToDoListPageViewController의 인스턴스 생성
//        let navigationController = UINavigationController(rootViewController: toDoListViewController)
//
//        navigationController.modalPresentationStyle = .fullScreen
//        present(navigationController, animated: true, completion: nil) // 내비게이션 컨트롤러를 표시
//    }
    
    @objc func CompletedButtonDidTap() {
        // ToDoListPageViewController 대신 해당 페이지의 루트 뷰 컨트롤러로 감싸진 내비게이션 컨트롤러를 만듭니다.
        let completedViewController = CompletedViewController() // ToDoListPageViewController의 인스턴스 생성
        self.navigationController?.pushViewController(completedViewController, animated: true)
    }
    
    
    @objc func ProfileButtonDidTap() {
        // ToDoListPageViewController 대신 해당 페이지의 루트 뷰 컨트롤러로 감싸진 내비게이션 컨트롤러를 만듭니다.
        let profilePageViewController = ProfilePageViewController() // ToDoListPageViewController의 인스턴스 생성
        self.navigationController?.pushViewController(profilePageViewController, animated: true)
    }
}
