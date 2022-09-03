//
//  Typealias.swift
//  EncryptedMessenger
//
//  Created by Hlib Sobolevskyi on 02.09.2022.
//

#if os(iOS) || os(watchOS) || os(tvOS)
    import UIKit
    typealias ViewController = UIViewController
    typealias View = UIView
    typealias Color = UIColor
    typealias Image = UIImage
#elseif os(macOS)
    import AppKit
    typealias ViewController = NSViewController
    typealias View = NSView
    typealias Image = NSImage
    typealias Color = NSColor
#endif
