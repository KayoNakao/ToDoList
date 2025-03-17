//
//  PillButton.swift
//  ToDoList
//
//  Created by Kayo on 2025-03-15.
//

import UIKit

class PillButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel?.font = UIFont.style(.body)
        backgroundColor = .link
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }

}
