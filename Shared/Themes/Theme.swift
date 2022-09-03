//
//  Theme.swift
//  EncryptedMessenger
//
//  Created by Hlib Sobolevskyi on 02.09.2022.
//

import Foundation

enum DefaultThemeObjectName: String {
    case Accent
    case UserMessage
    case Message
    case Background
    case SecondaryBackground
}
enum DefaultThemeColor: String {
    case Blue
    case Green
    case Yellow
    case Default
}

enum DefaultThemeColorLevel: Int {
    case Dark = 0
    case Moderate
    case Light
}

class Theme: Codable {
    var accentColor: Color = .systemBlue
    var userMessageColors: [Color] = [
        .themeColor(for: .UserMessage, with: .Blue, with: .Dark),
        .themeColor(for: .UserMessage, with: .Blue, with: .Moderate)
    ]
    var messageColors: [Color]? = /*[
        .themeColor(for: .Message, with: .Default, with: .Dark),
        .themeColor(for: .Message, with: .Default, with: .Moderate)
    ]*/ nil
    var backgroundColor: Color = .themeColor(for: .Background, with: .Blue, with: .Moderate)
    var secondaryBackgroundColor: Color = .themeColor(for: .SecondaryBackground, with: .Blue, with: .Moderate)
    var backgroundImage: Image?
    
    init() { }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(accentColor.toHex(), forKey: .accentColor)
        try container.encode(userMessageColors.map { $0.toHex() }, forKey: .userMessageColors)
        
        switch messageColors {
        case .some(let colors):
            try container.encode(colors.map { $0.toHex() }, forKey: .messageColors)
        case .none:
            try container.encodeNil(forKey: .messageColors)
        }
        
        try container.encode(backgroundColor.toHex(), forKey: .backgroundColor)
        try container.encode(secondaryBackgroundColor.toHex(), forKey: .secondaryBackgroundColor)
        
        switch backgroundImage?.tiffRepresentation {
        case .some(let data):
            try container.encode(data, forKey: .backgroundImage)
        case .none:
            try container.encodeNil(forKey: .backgroundImage)
        }
    }
    
    required init(from decoder: Decoder) throws {        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        accentColor = Color(hex: try container.decode(String.self, forKey: .accentColor))
        userMessageColors = (try container.decode([String].self, forKey: .userMessageColors)).map { Color(hex: $0) }
        
        if let colorsHex = try container.decode([String]?.self, forKey: .messageColors) {
            messageColors = colorsHex.map { Color(hex: $0) }
        }
        
        backgroundColor = Color(hex: try container.decode(String.self, forKey: .backgroundColor))
        secondaryBackgroundColor = Color(hex: try container.decode(String.self, forKey: .secondaryBackgroundColor))
        
        if let imgData = try container.decode(Data?.self, forKey: .backgroundImage) {
            backgroundImage = Image(data: imgData)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case accentColor
        case userMessageColors
        case messageColors
        case backgroundColor
        case secondaryBackgroundColor
        case backgroundImage
    }
}
