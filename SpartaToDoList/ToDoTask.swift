//
//  Task.swift
//  SpartaToDoList
//
//  Created by t2023-m0064 on 2023/09/22.
//

import Foundation

struct ToDoTask: Codable {
    var id: UUID
    var title: String
    var isCompleted: Bool
    var category: ToDoTaskCategory
}



enum ToDoTaskCategory: String, CaseIterable, Codable {
    case normal
    case important
    
    func toIndex() -> Int{
        Self.allCases.firstIndex(of: self) ?? 0
    }
    static func category(from index: Int) -> Self? {
        Self.allCases.indices ~= index ? Self.allCases[index] : nil
    }
}
