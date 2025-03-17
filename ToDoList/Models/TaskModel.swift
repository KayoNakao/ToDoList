//
//  TaskModel.swift
//  ToDoList
//
//  Created by Kayo on 2025-03-14.
//

import Foundation
import RealmSwift

struct Task {
    
    let id: String
    let category: Category
    let caption: String
    let createDate: Date
    var isComplete: Bool
}

class LocalTask {
    
    @Persisted(primaryKey: true) var _id: String
    @Persisted var category = Category.study
    @Persisted var capion = ""
    @Persisted var createDate = Date()
    @Persisted var isComplete = false
}
