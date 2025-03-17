//
//  FontType.swift
//  ToDoList
//
//  Created by Kayo on 2025-03-14.
//

import UIKit

extension UIFont {

    convenience init(type: FontType, size: FontSize) {
        self.init(name: type.name, size: size.value)!
    }
    
    static func style(_ style: FontStyle) -> UIFont {
        return style.font
    }
}

enum FontType: String {
    case robotoBlack = "Roboto-Black"
    case robotoRegular = "Roboto-Regular"
    case robotoSemiBold = "Roboto-SemiBold"
}

extension FontType {
    
    var name: String {
        return self.rawValue
    }
}

enum FontSize {
    case custom(Double)
    case theme(FontStyle)
}

extension FontSize {
    
    var value: Double {
        switch self {
        case .custom(let customSize):
            return customSize
        case .theme(let style):
            return style.size
        }
    }
}

enum FontStyle {
    case title
    case subTitle
    case body
    case caption
}

extension FontStyle {
    
    var size: Double {
        switch self {
        case .title:
            return 32
        case .subTitle:
            return 26
        case .body:
            return 16
        case .caption:
            return 14
        }
    }
    
    var fontDescription: FontDescription {
        switch self {
        case .title:
            return FontDescription(font: .robotoBlack, size: .theme(.title), style: .title1)
        case .subTitle:
            return FontDescription(font: .robotoSemiBold, size: .theme(.subTitle), style: .title2)
        case .body:
            return FontDescription(font: .robotoRegular, size: .theme(.body), style: .body)
        case .caption:
            return FontDescription(font: .robotoRegular, size: .theme(.caption), style: .caption1)
        }
    }
    
    var font: UIFont {
        guard let font = UIFont(name: fontDescription.font.name, size: fontDescription.size.value) else {
            return UIFont.preferredFont(forTextStyle: fontDescription.style)
        }
        let fontMetrics = UIFontMetrics(forTextStyle: fontDescription.style)
        return fontMetrics.scaledFont(for: font)
    }
}

struct FontDescription {
    let font: FontType
    let size: FontSize
    let style: UIFont.TextStyle
}
