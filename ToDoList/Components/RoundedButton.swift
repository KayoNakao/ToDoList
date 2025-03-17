//
//  RoundedButton.swift
//  ToDoList
//
//  Created by Kayo on 2025-03-15.
//

import UIKit

class RoundedButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel?.font = UIFont.style(.body)
        backgroundColor = .link
        titleLabel?.textAlignment = .center
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 5
    }
}
