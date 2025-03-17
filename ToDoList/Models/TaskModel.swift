//
//  TaskModel.swift
//  ToDoList
//
//  Created by Kayo on 2025-03-14.
//

import Foundation

struct Task {
    
    let id: String
    let category: Category
    let caption: String
    let createDate: Date
    var isComplete: Bool
}
