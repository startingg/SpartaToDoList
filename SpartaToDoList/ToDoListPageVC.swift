//
//  File.swift
//  SpartaToDoList
//
//  Created by t2023-m0064 on 2023/09/20.
//

import Foundation
import UIKit




class ToDoListPageViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
//    let backButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("< Back", for: .normal)
//        button.setTitleColor(.systemBlue, for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 20)
//        button.layer.cornerRadius = 50 / 2
//        button.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
//        return button
//    }()
//
//    func configureButtons() {
//        backButton.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(backButton)
//
//        NSLayoutConstraint.activate([
//            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
//            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
//            backButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
//            backButton.heightAnchor.constraint(equalToConstant: 64),
//        ])}
    
    
    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    var items = [String]() // 할 일을 저장할 배열
    var completedTasks = [Bool]() // 완료 여부를 저장할 배열
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = .white
        
//        configureButtons()
        
        // UserDefaults에서 할 일 목록을 불러옴
        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? []
        // 초기 완료 여부 설정 (모두 미완료로 초기화)
        self.completedTasks = Array(repeating: false, count: self.items.count)

        title = "To Do List" // 네비게이션 바의 타이틀 설정

        view.addSubview(table) // TableView를 뷰에 추가
        table.dataSource = self // TableView의 데이터 소스를 self로 설정하여 이 클래스의 메서드들이 호출되도록 함
        table.delegate = self // TableView의 delegate를 self로 설정하여 행 선택 이벤트를 처리할 수 있도록 함

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        // 오른쪽 상단에 "+" 버튼을 추가하고, 버튼을 누르면 didTapAdd 메서드가 호출되도록 합니다.
    }

    // 할 일 목록을 UserDefaults에 저장하는 함수
    private func saveItems() {
        UserDefaults.standard.setValue(items, forKey: "items")
    }

    // 완료 여부를 UserDefaults에 저장하는 함수
    private func saveCompletedTasks() {
        UserDefaults.standard.setValue(completedTasks, forKey: "completedTasks")
    }

    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Item", message: "Enter new to do list item!", preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Enter Item..."
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] (_) in
            if let field = alert.textFields?.first {
                if let text = field.text, !text.isEmpty {
                    // 새로운 할 일을 출력하고, UserDefaults를 사용하여 할 일 목록을 저장합니다.
                    print(text)
                    DispatchQueue.main.async {
                        self?.items.append(text)
                        self?.completedTasks.append(false) // 새로운 할 일은 미완료 상태로 추가됩니다.

                        // 배열에 할 일과 완료 여부를 추가하고, TableView를 다시 로드하여 목록을 갱신합니다.
                        self?.saveItems()
                        self?.saveCompletedTasks()
                        self?.table.reloadData()
                    }
                }
            }
        }))

        present(alert, animated: true)
    }

    // 할 일 목록을 삭제하는 기능 추가
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 배열과 UserDefaults에서 해당 위치의 할 일과 완료 여부를 삭제합니다.
            items.remove(at: indexPath.row)
            completedTasks.remove(at: indexPath.row)
            saveItems()
            saveCompletedTasks()

            // TableView에서 해당 행을 삭제합니다.
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    // TableView가 레이아웃될 때 TableView의 프레임을 뷰의 전체 크기로 설정합니다.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }

    // TableView의 행 개수를 반환합니다.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    // 각 행에 해당하는 셀을 반환합니다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // 해당 인덱스의 할 일을 셀의 텍스트로 표시합니다.
        cell.textLabel?.text = items[indexPath.row]

        // 해당 인덱스의 완료 여부를 가져와서 체크박스로 설정합니다.
        if completedTasks[indexPath.row] {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    // 특정 행을 선택했을 때 완료 여부를 토글하고, 체크박스를 갱신하는 함수입니다.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        completedTasks[indexPath.row].toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)

        // 선택한 할 일의 완료 여부를 저장합니다.
        saveCompletedTasks()
    }
    
//    @objc func backButtonDidTap() {
//        // ToDoListPageViewController 대신 해당 페이지의 루트 뷰 컨트롤러로 감싸진 내비게이션 컨트롤러를 만듭니다.
//        self.navigationController?.popViewController(animated: true)
//    }
}
