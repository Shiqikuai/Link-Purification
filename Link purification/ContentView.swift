//
//  ContentView.swift
//  Link purification
//
//  Created by shiqikuai on 2025/4/17.
//

import SwiftUI

struct AnimatedInputField: View {
    @Binding var text: String
    @State private var isFocused: Bool = false
    @State private var placeholder: String = "在这里输入或粘贴文本..."
    @EnvironmentObject private var windowManager: WindowManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .symbolEffect(.bounce, options: .repeating, value: isFocused)
                Text("输入文本")
                    .font(.headline)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                Spacer()
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                        // 清空 windowManager 的剪贴板内容
                        windowManager.clipboardContent = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.gray, .gray.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.gray.opacity(0.7))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 12)
                }
                
                TextEditor(text: $text)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .frame(minHeight: 150, maxHeight: 300)
                    .padding(8)
                    .onTapGesture {
                        isFocused = true
                    }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: isFocused ? .blue.opacity(0.3) : .gray.opacity(0.1), radius: isFocused ? 8 : 4, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isFocused ? Color.blue : Color.gray.opacity(0.3), lineWidth: isFocused ? 2 : 1)
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
    }
}

struct LinkItem: View {
    let link: String
    @State private var isHovered: Bool = false
    @State private var showCopiedToast: Bool = false
    @State private var isAppeared: Bool = false
    
    private func getLinkIcon() -> String {
        guard let url = URL(string: link) else { return "link.circle.fill" }
        
        let host = url.host?.lowercased() ?? ""
        
        // 磁力链接
        if link.lowercased().hasPrefix("magnet:") {
            return "arrow.down.circle.fill"  // 使用下载图标代替磁力链接图标
        }
        
        // 社交媒体
        if host.contains("twitter.com") || host.contains("x.com") {
            return "message.circle.fill"
        } else if host.contains("facebook.com") {
            return "person.2.circle.fill"
        } else if host.contains("instagram.com") {
            return "camera.circle.fill"
        } else if host.contains("youtube.com") {
            return "play.circle.fill"
        } else if host.contains("linkedin.com") {
            return "briefcase.circle.fill"
        } else if host.contains("github.com") {
            return "chevron.left.forwardslash.chevron.right.circle.fill"
        } else if host.contains("reddit.com") {
            return "bubble.left.circle.fill"
        } else if host.contains("pinterest.com") {
            return "pin.circle.fill"
        } else if host.contains("tiktok.com") {
            return "video.circle.fill"
        } else if host.contains("weibo.com") {
            return "message.circle.fill"
        } else if host.contains("zhihu.com") {
            return "questionmark.circle.fill"
        } else if host.contains("bilibili.com") {
            return "play.circle.fill"
        } else if host.contains("douyin.com") {
            return "video.circle.fill"
        } else if host.contains("xiaohongshu.com") {
            return "photo.circle.fill"
        }
        
        // 文件类型
        if link.lowercased().hasSuffix(".pdf") {
            return "doc.text.fill"
        } else if link.lowercased().hasSuffix(".doc") || link.lowercased().hasSuffix(".docx") {
            return "doc.fill"
        } else if link.lowercased().hasSuffix(".xls") || link.lowercased().hasSuffix(".xlsx") {
            return "tablecells.fill"
        } else if link.lowercased().hasSuffix(".ppt") || link.lowercased().hasSuffix(".pptx") {
            return "rectangle.stack.fill"
        }
        
        // 图片类型
        if link.lowercased().hasSuffix(".jpg") || link.lowercased().hasSuffix(".jpeg") || 
           link.lowercased().hasSuffix(".png") || link.lowercased().hasSuffix(".gif") {
            return "photo.circle.fill"
        }
        
        // 视频类型
        if link.lowercased().hasSuffix(".mp4") || link.lowercased().hasSuffix(".mov") || 
           link.lowercased().hasSuffix(".avi") {
            return "video.circle.fill"
        }
        
        // 音频类型
        if link.lowercased().hasSuffix(".mp3") || link.lowercased().hasSuffix(".wav") {
            return "music.note.circle.fill"
        }
        
        // 压缩文件
        if link.lowercased().hasSuffix(".zip") || link.lowercased().hasSuffix(".rar") {
            return "folder.circle.fill"
        }
        
        // 代码相关
        if link.lowercased().hasSuffix(".html") || link.lowercased().hasSuffix(".css") || 
           link.lowercased().hasSuffix(".js") || link.lowercased().hasSuffix(".py") {
            return "chevron.left.forwardslash.chevron.right.circle.fill"
        }
        
        // 新闻和博客
        if host.contains("news") || host.contains("blog") {
            return "newspaper.circle.fill"
        }
        
        // 购物网站
        if host.contains("amazon") || host.contains("taobao") || host.contains("jd") || host.contains("tmall") {
            return "cart.circle.fill"
        }
        
        // 搜索引擎
        if host.contains("google") || host.contains("baidu") || host.contains("bing") {
            return "magnifyingglass.circle.fill"
        }
        
        // 邮件服务
        if host.contains("mail") || host.contains("gmail") || host.contains("outlook") {
            return "envelope.circle.fill"
        }
        
        // 默认图标
        return "link.circle.fill"
    }
    
    private func getGradientColors() -> [Color] {
        guard let url = URL(string: link) else { return [.blue, .purple] }
        
        let host = url.host?.lowercased() ?? ""
        
        // 磁力链接
        if link.lowercased().hasPrefix("magnet:") {
            return [Color(hex: "#FF6B6B"), Color(hex: "#FF8E8E")]  // 磁力链接红色
        }
        
        // 社交媒体 - 使用品牌色或接近的颜色
        if host.contains("twitter.com") || host.contains("x.com") {
            return [Color(hex: "#1DA1F2"), Color(hex: "#0C85D0")]  // Twitter蓝
        } else if host.contains("facebook.com") {
            return [Color(hex: "#4267B2"), Color(hex: "#2B4B94")]  // Facebook蓝
        } else if host.contains("instagram.com") {
            return [Color(hex: "#E4405F"), Color(hex: "#FD1D1D")]  // Instagram渐变红
        } else if host.contains("youtube.com") {
            return [Color(hex: "#FF0000"), Color(hex: "#CC0000")]  // YouTube红
        } else if host.contains("linkedin.com") {
            return [Color(hex: "#0077B5"), Color(hex: "#005582")]  // LinkedIn蓝
        } else if host.contains("github.com") {
            return [Color(hex: "#24292E"), Color(hex: "#1B1F23")]  // GitHub深色
        } else if host.contains("reddit.com") {
            return [Color(hex: "#FF4500"), Color(hex: "#FF5700")]  // Reddit橙
        } else if host.contains("weibo.com") {
            return [Color(hex: "#DF2029"), Color(hex: "#B2191F")]  // 微博红
        } else if host.contains("zhihu.com") {
            return [Color(hex: "#0066FF"), Color(hex: "#0047B2")]  // 知乎蓝
        } else if host.contains("bilibili.com") {
            return [Color(hex: "#FB7299"), Color(hex: "#FC9DB6")]  // B站粉
        } else if host.contains("douyin.com") {
            return [Color(hex: "#000000"), Color(hex: "#25F4EE")]  // 抖音渐变
        } else if host.contains("xiaohongshu.com") {
            return [Color(hex: "#FE2C55"), Color(hex: "#FF6C6C")]  // 小红书红
        }
        
        // 文件类型 - 使用办公软件传统色调
        if link.lowercased().hasSuffix(".pdf") {
            return [Color(hex: "#FF3850"), Color(hex: "#FF6B81")]  // PDF红
        } else if link.lowercased().hasSuffix(".doc") || link.lowercased().hasSuffix(".docx") {
            return [Color(hex: "#2B579A"), Color(hex: "#4285F4")]  // Word蓝
        } else if link.lowercased().hasSuffix(".xls") || link.lowercased().hasSuffix(".xlsx") {
            return [Color(hex: "#217346"), Color(hex: "#33C481")]  // Excel绿
        } else if link.lowercased().hasSuffix(".ppt") || link.lowercased().hasSuffix(".pptx") {
            return [Color(hex: "#D24726"), Color(hex: "#FF8F6B")]  // PPT橙
        }
        
        // 多媒体文件 - 鲜艳的色彩
        if link.lowercased().hasSuffix(".jpg") || link.lowercased().hasSuffix(".jpeg") || 
           link.lowercased().hasSuffix(".png") || link.lowercased().hasSuffix(".gif") {
            return [Color(hex: "#4FACFE"), Color(hex: "#00F2FE")]  // 清新蓝
        }
        
        if link.lowercased().hasSuffix(".mp4") || link.lowercased().hasSuffix(".mov") || 
           link.lowercased().hasSuffix(".avi") {
            return [Color(hex: "#6D45E6"), Color(hex: "#A16BFE")]  // 活力紫
        }
        
        if link.lowercased().hasSuffix(".mp3") || link.lowercased().hasSuffix(".wav") {
            return [Color(hex: "#FF3CAC"), Color(hex: "#784BA0")]  // 音乐粉紫
        }
        
        // 压缩文件 - 稳重的色调
        if link.lowercased().hasSuffix(".zip") || link.lowercased().hasSuffix(".rar") {
            return [Color(hex: "#525252"), Color(hex: "#737373")]  // 深灰
        }
        
        // 代码文件 - 科技感色调
        if link.lowercased().hasSuffix(".html") || link.lowercased().hasSuffix(".css") || 
           link.lowercased().hasSuffix(".js") || link.lowercased().hasSuffix(".py") {
            return [Color(hex: "#2CD8D5"), Color(hex: "#6B8DD6")]  // 科技蓝绿
        }
        
        // 功能类型网站 - 实用的色调
        if host.contains("news") || host.contains("blog") {
            return [Color(hex: "#48C6EF"), Color(hex: "#6F86D6")]  // 新闻蓝
        }
        
        if host.contains("amazon") || host.contains("taobao") || 
           host.contains("jd") || host.contains("tmall") {
            return [Color(hex: "#FF9A9E"), Color(hex: "#FAD0C4")]  // 购物粉
        }
        
        if host.contains("google") || host.contains("baidu") || host.contains("bing") {
            return [Color(hex: "#4285F4"), Color(hex: "#34A853")]  // 搜索引擎色
        }
        
        if host.contains("mail") || host.contains("gmail") || host.contains("outlook") {
            return [Color(hex: "#FF5858"), Color(hex: "#F09819")]  // 邮件橙红
        }
        
        // 默认颜色
        return [Color(hex: "#4A90E2"), Color(hex: "#67B8F7")]  // 默认蓝
    }
    
    private func getLinkStyle() -> (background: Color, border: Color, hover: Color) {
        guard let url = URL(string: link) else { 
            return (Color(hex: "#F0F2F5"), Color(hex: "#1A2542"), Color(hex: "#FFD84D"))
        }
        
        let host = url.host?.lowercased() ?? ""
        
        // 磁力链接
        if link.lowercased().hasPrefix("magnet:") {
            return (Color(hex: "#FFE6E6"), Color(hex: "#FF6B6B"), Color(hex: "#FFB3B3"))
        }
        
        // 社交媒体
        if host.contains("twitter.com") || host.contains("x.com") {
            return (Color(hex: "#E8F5FD"), Color(hex: "#1DA1F2"), Color(hex: "#BAE3FF"))
        } else if host.contains("facebook.com") {
            return (Color(hex: "#E7F3FF"), Color(hex: "#4267B2"), Color(hex: "#B7D4FF"))
        } else if host.contains("instagram.com") {
            return (Color(hex: "#FCE7EB"), Color(hex: "#E4405F"), Color(hex: "#FFB1C1"))
        } else if host.contains("youtube.com") {
            return (Color(hex: "#FFE6E6"), Color(hex: "#FF0000"), Color(hex: "#FFB3B3"))
        } else if host.contains("linkedin.com") {
            return (Color(hex: "#E6F3F9"), Color(hex: "#0077B5"), Color(hex: "#B3E0FF"))
        } else if host.contains("github.com") {
            return (Color(hex: "#F0F2F5"), Color(hex: "#24292E"), Color(hex: "#D0D7DE"))
        } else if host.contains("weibo.com") {
            return (Color(hex: "#FFE7E8"), Color(hex: "#DF2029"), Color(hex: "#FFB3B6"))
        } else if host.contains("zhihu.com") {
            return (Color(hex: "#E6F0FF"), Color(hex: "#0066FF"), Color(hex: "#B3D1FF"))
        } else if host.contains("bilibili.com") {
            return (Color(hex: "#FFF0F5"), Color(hex: "#FB7299"), Color(hex: "#FFD6E5"))
        }
        
        // 文件类型
        if link.lowercased().hasSuffix(".pdf") {
            return (Color(hex: "#FFE8EA"), Color(hex: "#FF3850"), Color(hex: "#FFB3BC"))
        } else if link.lowercased().hasSuffix(".doc") || link.lowercased().hasSuffix(".docx") {
            return (Color(hex: "#E7ECF7"), Color(hex: "#2B579A"), Color(hex: "#B3C6E7"))
        } else if link.lowercased().hasSuffix(".xls") || link.lowercased().hasSuffix(".xlsx") {
            return (Color(hex: "#E8F5ED"), Color(hex: "#217346"), Color(hex: "#B3E0C4"))
        } else if link.lowercased().hasSuffix(".ppt") || link.lowercased().hasSuffix(".pptx") {
            return (Color(hex: "#FFE9E3"), Color(hex: "#D24726"), Color(hex: "#FFB8A3"))
        }
        
        // 多媒体文件
        if link.lowercased().hasSuffix(".jpg") || link.lowercased().hasSuffix(".jpeg") || 
           link.lowercased().hasSuffix(".png") || link.lowercased().hasSuffix(".gif") {
            return (Color(hex: "#E6F7FF"), Color(hex: "#4FACFE"), Color(hex: "#B3E0FF"))
        }
        
        if link.lowercased().hasSuffix(".mp4") || link.lowercased().hasSuffix(".mov") || 
           link.lowercased().hasSuffix(".avi") {
            return (Color(hex: "#F0E8FF"), Color(hex: "#6D45E6"), Color(hex: "#D4B3FF"))
        }
        
        if link.lowercased().hasSuffix(".mp3") || link.lowercased().hasSuffix(".wav") {
            return (Color(hex: "#FFE6F7"), Color(hex: "#FF3CAC"), Color(hex: "#FFB3E6"))
        }
        
        // 压缩文件
        if link.lowercased().hasSuffix(".zip") || link.lowercased().hasSuffix(".rar") {
            return (Color(hex: "#F0F0F0"), Color(hex: "#525252"), Color(hex: "#D1D1D1"))
        }
        
        // 代码文件
        if link.lowercased().hasSuffix(".html") || link.lowercased().hasSuffix(".css") || 
           link.lowercased().hasSuffix(".js") || link.lowercased().hasSuffix(".py") {
            return (Color(hex: "#E6F9F8"), Color(hex: "#2CD8D5"), Color(hex: "#B3F0EE"))
        }
        
        // 功能类型网站
        if host.contains("news") || host.contains("blog") {
            return (Color(hex: "#E8F3FF"), Color(hex: "#48C6EF"), Color(hex: "#B3E0FF"))
        }
        
        if host.contains("amazon") || host.contains("taobao") || 
           host.contains("jd") || host.contains("tmall") {
            return (Color(hex: "#FFF0F0"), Color(hex: "#FF9A9E"), Color(hex: "#FFD6D6"))
        }
        
        if host.contains("google") || host.contains("baidu") || host.contains("bing") {
            return (Color(hex: "#E8F0FF"), Color(hex: "#4285F4"), Color(hex: "#B3D1FF"))
        }
        
        if host.contains("mail") || host.contains("gmail") || host.contains("outlook") {
            return (Color(hex: "#FFF0E6"), Color(hex: "#FF5858"), Color(hex: "#FFB3B3"))
        }
        
        // 默认颜色
        return (Color(hex: "#F0F2F5"), Color(hex: "#1A2542"), Color(hex: "#FFD84D"))
    }
    
    // 添加用于解析十六进制颜色的扩展
    private func color(hex: String) -> Color {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        return Color(red: red, green: green, blue: blue)
    }
    
    var body: some View {
        Button(action: {
            if link.lowercased().hasPrefix("magnet:") {
                // 使用 NSWorkspace 打开磁力链接，这会触发系统默认的磁力链接处理程序
                NSWorkspace.shared.open(URL(string: link)!)
            } else if let url = URL(string: link) {
                NSWorkspace.shared.open(url)
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: getLinkIcon())
                    .font(.system(size: 22))
                    .foregroundStyle(Color(hex: "#1A2542"))
                    .scaleEffect(isAppeared ? 1 : 0.5)
                    .opacity(isAppeared ? 1 : 0)
                
                Text(link)
                    .foregroundColor(Color(hex: "#1A2542"))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .opacity(isAppeared ? 1 : 0)
                    .offset(x: isAppeared ? 0 : -10)
                
                Spacer(minLength: 12)
                
                Button(action: {
                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.setString(link, forType: .string)
                    showCopiedToast = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showCopiedToast = false
                    }
                }) {
                    Image(systemName: "doc.on.doc.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(Color(hex: "#1A2542"))
                        .opacity(isAppeared ? 1 : 0)
                        .scaleEffect(isAppeared ? 1 : 0.5)
                }
                .buttonStyle(.plain)
                .overlay(
                    Group {
                        if showCopiedToast {
                            Text("已复制")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(hex: "#1A2542"))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .offset(y: -25)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                )
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isHovered ? Color(hex: "#FFD84D") : .white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(hex: "#1A2542"), lineWidth: 2)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovered = hovering
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.1)) {
                isAppeared = true
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isHovered)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showCopiedToast)
    }
}

struct LinkList: View {
    let links: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "link.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(Color(hex: "#1A2542"))
                Text("提取到的链接")
                    .font(.headline)
                    .foregroundColor(Color(hex: "#1A2542"))
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "number.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(Color(hex: "#1A2542"))
                    Text("\(links.count) 个链接")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "#1A2542"))
                }
            }
            .animation(.easeInOut(duration: 0.3), value: links.count)
            
            VStack {
                if links.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: "link.badge.plus")
                            .font(.system(size: 40))
                            .foregroundStyle(Color(hex: "#1A2542").opacity(0.3))
                            .transition(.scale.combined(with: .opacity))
                        Text("在上方输入或粘贴文本，自动提取链接")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "#1A2542").opacity(0.5))
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    .frame(maxWidth: .infinity, minHeight: 120)
                    .padding()
                    .transition(.opacity)
                } else {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 300, maximum: .infinity), spacing: 16)
                    ], spacing: 16) {
                        ForEach(links, id: \.self) { link in
                            LinkItem(link: link)
                                .transition(.asymmetric(
                                    insertion: .scale(scale: 0.9)
                                        .combined(with: .opacity)
                                        .combined(with: .offset(y: 20)),
                                    removal: .scale(scale: 0.9)
                                        .combined(with: .opacity)
                                        .combined(with: .offset(y: -20))
                                ))
                        }
                    }
                    .padding()
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: links)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .shadow(color: Color(hex: "#1A2542").opacity(0.1), radius: 4, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(hex: "#1A2542").opacity(0.2), lineWidth: 2)
            )
        }
    }
}

struct ContentView: View {
    @State private var inputText: String = ""
    @State private var extractedLinks: [String] = []
    @State private var isAnimating: Bool = false
    @EnvironmentObject private var windowManager: WindowManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                HStack(spacing: 15) {
                    Image(systemName: "link.badge.plus")
                        .font(.system(size: 40))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .symbolEffect(.bounce, options: .repeating, value: isAnimating)
                    Text("链接提取器")
                        .font(.title)
                        .bold()
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
                .padding(.top, 45)
                
                AnimatedInputField(text: $inputText)
                    .onChange(of: inputText) { oldValue, newValue in
                        extractLinks()
                    }
                    .onChange(of: windowManager.clipboardContent) { oldValue, newValue in
                        // 只要剪贴板内容不为空，就更新输入文本
                        if !newValue.isEmpty {
                            inputText = newValue
                            extractLinks()
                        }
                    }
                
                LinkList(links: extractedLinks)
                
                Spacer(minLength: 20)
            }
            .padding(.horizontal, 20)
        }
        .frame(minWidth: 600, minHeight: 400)
        .background(Color(.windowBackgroundColor))
        .ignoresSafeArea(.all)
    }
    
    private func extractLinks() {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let range = NSRange(location: 0, length: inputText.utf16.count)
            
            // 使用有序集合来存储链接和它们的位置
            var linksWithPositions: [(position: Int, link: String)] = []
            
            // 从NSDataDetector获取链接
            let matches = detector.matches(in: inputText, range: range)
            for match in matches {
                if let url = match.url {
                    linksWithPositions.append((match.range.location, url.absoluteString))
                }
            }
            
            // 使用正则表达式获取额外的链接，包括磁力链接
            let urlPattern = "(?i)(https?://[^\\s/$.?#].[^\\s]*|magnet:\\?[^\\s]+)"
            let regex = try NSRegularExpression(pattern: urlPattern)
            let additionalMatches = regex.matches(in: inputText, range: range)
            
            for match in additionalMatches {
                if let range = Range(match.range, in: inputText) {
                    let link = String(inputText[range])
                    linksWithPositions.append((match.range.location, link))
                }
            }
            
            // 按照位置排序
            linksWithPositions.sort { $0.position < $1.position }
            
            // 清理链接
            let cleanedLinks = linksWithPositions.compactMap { _, link -> String? in
                var cleanLink = link.trimmingCharacters(in: .whitespacesAndNewlines)
                
                // 移除链接末尾的标点符号
                if let lastChar = cleanLink.last,
                   [",", ".", ";", "›"].contains(lastChar) {
                    cleanLink = String(cleanLink.dropLast())
                }
                
                // 检查链接是否为空
                guard !cleanLink.isEmpty else { return nil }
                
                return cleanLink
            }
            
            // 去重但保持顺序
            var seen = Set<String>()
            extractedLinks = cleanedLinks.filter { link in
                if seen.contains(link) {
                    return false
                }
                seen.insert(link)
                return true
            }
            
            // 更新链接数量
            windowManager.linksCount = extractedLinks.count
            
        } catch {
            print("Error in link extraction: \(error)")
            extractedLinks = []
            windowManager.linksCount = 0
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(WindowManager())
}

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
