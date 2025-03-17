//
//  CategoryModel.swift
//  ToDoList
//
//  Created by Kayo on 2025-03-13.
//

import UIKit

enum Category:String, CaseIterable {
    case work = "Work", study = "Study", excercise = "Excercise"
    
    var color: UIColor {
        switch self {
        case .work:
            return UIColor.work
        case .study:
            return UIColor.study
        case .excercise:
            return UIColor.excercise
        }
    }
}

