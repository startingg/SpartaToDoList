//
//  TaskList.swift
//  SpartaToDoList
//
//  Created by t2023-m0064 on 2023/09/21.
//
//
import Foundation




struct ToDoTaskList {
    //    static let shared = TodoTaskList()
    private static let database = UserDefaults.standard
    private static let key = "ToDoTaskList"
    
    static func filterByCategory(category: ToDoTaskCategory) -> [ToDoTask]{
        return Self.taskList().filter { $0.category == category }
    }
    static func completeList() -> [ToDoTask]{
        return Self.taskList().filter{$0.isCompleted == true}
    }
    static func taskList() -> [ToDoTask]{
        
        if let encodedTaskList = ToDoTaskList.database.object(forKey: ToDoTaskList.key) as? Data, let taskList = try? JSONDecoder().decode([ToDoTask].self, from: encodedTaskList) {
            return taskList
        }
        return []
    }
    static func addTask(_ task: ToDoTask) {
        var taskList = Self.taskList()
        taskList.append(task)
        Self.updateTaskList(taskList)
    }
    
    static func updateTaskList(_ taskList: [ToDoTask]){
        if let encodedTaskList = try? JSONEncoder().encode(taskList){
            ToDoTaskList.database.set(encodedTaskList, forKey: ToDoTaskList.key)
        }
    }
    
    static func completeTask(task: ToDoTask, isCompleted: Bool){
        var list = Self.taskList()
        for index in 0 ..< list.count {
            if list[index].id == task.id {
                list[index].isCompleted = isCompleted
            }
        }
        updateTaskList(list)
    }
    
    static func editTitle(task: ToDoTask, title: String) {
        var list = Self.taskList()
        for index in 0 ..< list.count {
            if list[index].id == task.id {
                list[index].title = title
            }
        }
        updateTaskList(list)
    }
    
    static func editCategory(task: ToDoTask, category: ToDoTaskCategory) {
        var list = Self.taskList()
        for index in 0 ..< list.count {
            if list[index].id == task.id {
                list[index].category = category
            }
        }
        updateTaskList(list)
    }
    
    static func deleteTask(task: ToDoTask) {
    var list = Self.taskList()
    list.removeAll(where: {$0.id == task.id})
    updateTaskList(list)
  }
}
