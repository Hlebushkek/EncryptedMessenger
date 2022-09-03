//
//  Color + ThemeColors.swift
//  EncryptedMessenger
//
//  Created by Hlib Sobolevskyi on 03.09.2022.
//

extension Color {
    static func themeColor(for object: DefaultThemeObjectName,
                           with color: DefaultThemeColor,
                           with level: DefaultThemeColorLevel) -> Color {
        Color(named: object.rawValue + color.rawValue + String(level.rawValue)) ??
        Color(named: object.rawValue + color.rawValue) ??
        Color(named: object.rawValue) ??
        Color.clear
    }
}
