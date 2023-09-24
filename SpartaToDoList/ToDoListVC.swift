//
//  ToDoListVC.swift
//  SpartaToDoList
//
//  Created by t2023-m0064 on 2023/09/24.
//

import Foundation
import UIKit

class ToDoListPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var task: ToDoTask?
    
    //    var items = [String]() // 할 일을 저장할 배열
    //    var completedTasks = [Bool]() // 완료 여부를 저장할 배열
    //    var importantItems = [String]()
    var todo = [ToDoTask]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        view.backgroundColor = .white
        
        // UserDefaults에서 할 일 목록을 불러옴
        //        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? []
        ////        self.importantItems = UserDefaults.standard.stringArray(forKey: "importantItems") ?? []
        //        // 초기 완료 여부 설정 (모두 미완료로 초기화)
        //        self.completedTasks = Array(repeating: false, count: self.items.count)
        
        title = "To Do List" // 네비게이션 바의 타이틀 설정
        
        view.addSubview(table) // TableView를 뷰에 추가
        table.dataSource = self // TableView의 데이터 소스를 self로 설정하여 이 클래스의 메서드들이 호출되도록 함
        table.delegate = self // TableView의 delegate를 self로 설정하여 행 선택 이벤트를 처리할 수 있도록 함
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        // 오른쪽 상단에 "+" 버튼을 추가하고, 버튼을 누르면 didTapAdd 메서드가 호출되도록 합니다.
        // 왼쪽 상단에 바버튼 추가 코드
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Back", image: nil , target: self, action: #selector(backButtonDidTap))
    }
    
    // 할 일 목록을 UserDefaults에 저장하는 함수
    
    private func saveTodo() {
        UserDefaults.standard.setValue(todo, forKey: "todo")
    }
    
    //    private func saveItems() {
    //        UserDefaults.standard.setValue(items, forKey: "items")
    //    }
    //
    //    private func saveImportantItems() {
    //        UserDefaults.standard.setValue(importantItems, forKey: "importantItems")
    //    }
    //
    //    // 완료 여부를 UserDefaults에 저장하는 함수
    //    private func saveCompletedTasks() {
    //        UserDefaults.standard.setValue(completedTasks, forKey: "completedTasks")
    //    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Item",
                                      message: "Enter new to do list item!",
                                      preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Enter Item..."
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Done", style: .default) { [weak self] _ in
            if let field = alert.textFields?.first {
                if let text = field.text, !text.isEmpty {
                    // 새로운 할 일을 출력하고, UserDefaults를 사용하여 할 일 목록을 저장합니다.
                    print(text)
                    let defaultCategory = ToDoTaskCategory.normal
                    let newItem = ToDoTask(id: UUID(),
                                           title: text,
                                           isCompleted: false,
                                           category: defaultCategory)
                    ToDoTaskList.addTask(newItem)
                    
                    //                    DispatchQueue.main.async {
                    //                        self?.todo.append(Task(id: UUID(), title: text, isCompleted: false, category: "일반"))
                    //                        self?.items.append(text)
                    //                        self?.completedTasks.append(false) // 새로운 할 일은 미완료 상태로 추가됩니다.
                    //
                    //                        // 배열에 할 일과 완료 여부를 추가하고, TableView를 다시 로드하여 목록을 갱신합니다.
                    //                        self?.saveItems()
                    //                        self?.saveCompletedTasks()
                    //                        self?.table.reloadData()
                    //                    }
                }
            }
        })
        
        alert.addAction(UIAlertAction(title: "Important!", style: .default, handler: { [weak self] _ in
            if let field = alert.textFields?.first {
                if let text = field.text, !text.isEmpty {
                    // 새로운 할 일을 출력하고, UserDefaults를 사용하여 할 일 목록을 저장합니다.
                    print(text)
                    let defaultCategory = ToDoTaskCategory.important
                    let newItem = ToDoTask(id: UUID(),
                                           title: text,
                                           isCompleted: false,
                                           category: defaultCategory)
                    ToDoTaskList.addTask(newItem)
                    
                    //                    DispatchQueue.main.async {
                    //                        self?.todo.append(Task(id: UUID(), title: text, isCompleted: false, category: "중요"))
                    //                        self?.importantItems.append(text)
                    //                        self?.completedTasks.append(false) // 새로운 할 일은 미완료 상태로 추가됩니다.
                    //
                    //                        // 배열에 할 일과 완료 여부를 추가하고, TableView를 다시 로드하여 목록을 갱신합니다.
                    //                        self?.saveItems()
                    //                        self?.saveImportantItems()
                    //                        self?.saveCompletedTasks()
                    //                        self?.table.reloadData()
                    //                    }
                }
            }
        }))
        present(alert, animated: true)
    }
}

extension ToDoListPageViewController {
    
        
    // 할 일 목록을 삭제하는 기능 추가
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 배열과 UserDefaults에서 해당 위치의 할 일과 완료 여부를 삭제합니다.
            
            ToDoTaskList.deleteTask(task: task!)
                
            // TableView에서 해당 행을 삭제합니다.
        }
    }
        
    // TableView가 레이아웃될 때 TableView의 프레임을 뷰의 전체 크기로 설정합니다.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
        
    // TableView의 행 개수를 반환합니다.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return items.count + importantItems.count
        return todo.count
    }
        
    // 각 행에 해당하는 셀을 반환합니다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
        // 해당 인덱스의 할 일을 셀의 텍스트로 표시합니다.
        //        cell.textLabel?.text = items[indexPath.row]
        let item = indexPath.row < items.count ? items[indexPath.row] : importantItems[indexPath.row - items.count]
        cell.textLabel?.text = item
            
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
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let category = ToDoTaskCategory.category(from: section) else {return nil}
        let titleHeader = category.rawValue
        return ToDoTaskList.filterByCategory(category: category).isEmpty ? nil : titleHeader
    }
}
