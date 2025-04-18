//
//  Link_purificationApp.swift
//  Link purification
//
//  Created by shiqikuai on 2025/4/17.
//

import SwiftUI
import HotKey
import AppKit

class WindowManager: ObservableObject {
    private var hotKey: HotKey?
    @Published var isWindowVisible = true
    private var mainWindow: NSWindow?
    
    init() {
        setupHotKey()
    }
    
    private func setupHotKey() {
        hotKey = HotKey(key: .t, modifiers: [.command])
        hotKey?.keyDownHandler = { [weak self] in
            self?.toggleWindow()
        }
    }
    
    func setMainWindow(_ window: NSWindow) {
        self.mainWindow = window
        // 设置窗口的默认大小和位置
        let screenFrame = NSScreen.main?.visibleFrame ?? .zero
        let windowSize = NSSize(width: 800, height: 600)
        let windowOrigin = NSPoint(
            x: screenFrame.midX - windowSize.width / 2,
            y: screenFrame.midY - windowSize.height / 2
        )
        window.setFrame(NSRect(origin: windowOrigin, size: windowSize), display: true)
        window.center() // 确保窗口居中
        
        // 设置窗口样式
        window.styleMask = [.titled, .closable, .miniaturizable, .resizable]
        window.title = "链接提取器"
        window.isMovableByWindowBackground = true
        
        // 显示窗口并激活应用
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func toggleWindow() {
        if let window = mainWindow {
            if window.isVisible {
                window.orderOut(nil)
                isWindowVisible = false
            } else {
                window.makeKeyAndOrderFront(nil)
                NSApp.activate(ignoringOtherApps: true)
                isWindowVisible = true
            }
        }
    }
}

@main
struct Link_purificationApp: App {
    @StateObject private var windowManager = WindowManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    if let window = NSApplication.shared.windows.first {
                        windowManager.setMainWindow(window)
                    }
                }
        }
    }
}
