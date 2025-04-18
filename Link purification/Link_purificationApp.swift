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
    @Published var clipboardContent: String = ""
    @Published var linksCount: Int = 0 {
        didSet {
            adjustWindowHeight()
        }
    }
    
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
        window.titlebarAppearsTransparent = true // 标题栏透明
        window.titleVisibility = .hidden // 隐藏标题
        window.styleMask = [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView] // 添加 fullSizeContentView 使内容延伸到标题栏
        window.isMovableByWindowBackground = true
        
        // 显示窗口并激活应用
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    private func adjustWindowHeight() {
        guard let window = mainWindow else { return }
        
        // 计算新的窗口高度
        // 基础高度为 600，每增加 4 个链接增加 100 像素高度
        let baseHeight: CGFloat = 600
        let additionalHeight = CGFloat((linksCount + 3) / 4) * 100
        let maxHeight = NSScreen.main?.visibleFrame.height ?? 1000
        let newHeight = min(baseHeight + additionalHeight, maxHeight - 100) // 保留一些边距
        
        // 获取当前窗口frame
        var frame = window.frame
        
        // 保持窗口顶部位置不变，只改变高度
        frame.origin.y = frame.origin.y + frame.height - newHeight
        frame.size.height = newHeight
        
        // 动画过渡到新的尺寸
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            window.animator().setFrame(frame, display: true)
        }
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
                
                // 每次显示窗口时都读取剪贴板内容
                DispatchQueue.main.async {
                    // 先清空内容
                    self.clipboardContent = ""
                    
                    // 延迟一小段时间后再设置新内容，确保清空操作被处理
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        // 读取新的剪贴板内容
                        if let clipboardString = NSPasteboard.general.string(forType: .string) {
                            self.clipboardContent = clipboardString
                        }
                    }
                }
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
                .environmentObject(windowManager)
                .onAppear {
                    DispatchQueue.main.async {
                        if let window = NSApplication.shared.windows.first {
                            windowManager.setMainWindow(window)
                        }
                    }
                }
        }
    }
}
