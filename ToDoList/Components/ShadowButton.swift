//
//  ShadowButton.swift
//  ToDoList
//
//  Created by Kayo on 2025-03-15.
//

import UIKit

@IBDesignable
class ShadowButton: UIButton {

    @IBInspectable
    var cornerRadius: CGFloat = 5 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable
    var background: UIColor? = .link {
        didSet {
            backgroundColor = background
        }
    }
    @IBInspectable
    var shadowColor: CGColor = UIColor.secondaryLink.cgColor {
        didSet {
            layer.shadowColor = shadowColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }

    func setupView() {
        titleLabel?.font = UIFont.style(.body)
        backgroundColor = background
        layer.masksToBounds = false
        layer.shadowOpacity = 1
        layer.shadowRadius = 0
        layer.shadowColor = shadowColor
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius
    }

}
