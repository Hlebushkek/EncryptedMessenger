//
//  AppDelegate.swift
//  EncryptedMessangerMac
//
//  Created by Gleb Sobolevsky on 11.08.2022.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        MessagesWebSocket.shared.setupWebSocket()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

