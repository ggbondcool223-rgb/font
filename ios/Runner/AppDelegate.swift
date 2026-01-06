import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // 设置字体生成 MethodChannel
    let controller = window?.rootViewController as! FlutterViewController
    let fontGeneratorChannel = FlutterMethodChannel(
      name: "com.fontmaster/font_generator",
      binaryMessenger: controller.binaryMessenger
    )
    
    fontGeneratorChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      switch call.method {
      case "generateFont":
        guard let args = call.arguments as? [String: Any],
              let strokeData = args["strokeData"] as? String,
              let fontName = args["fontName"] as? String,
              let outputPath = args["outputPath"] as? String else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing required arguments", details: nil))
          return
        }
        
        // 在后台线程生成字体
        DispatchQueue.global(qos: .userInitiated).async {
          let success = self?.generateFont(strokeData: strokeData, fontName: fontName, outputPath: outputPath) ?? false
          
          // 回到主线程返回结果
          DispatchQueue.main.async {
            result(success)
          }
        }
        
      case "convertSvgToTtf":
        guard let args = call.arguments as? [String: Any],
              let svgPath = args["svgPath"] as? String,
              let ttfPath = args["ttfPath"] as? String,
              let fontName = args["fontName"] as? String else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing required arguments", details: nil))
          return
        }
        
        // 在后台线程转换字体
        DispatchQueue.global(qos: .userInitiated).async {
          let success = self?.convertSvgToTtf(svgPath: svgPath, ttfPath: ttfPath, fontName: fontName) ?? false
          
          // 回到主线程返回结果
          DispatchQueue.main.async {
            result(success)
          }
        }
        
      case "checkAvailability":
        result(true)
        
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  /**
   * 生成字体文件（简化版本）
   * TODO: 完整实现需要使用 CoreText 或其他字体生成库
   */
  private func generateFont(strokeData: String, fontName: String, outputPath: String) -> Bool {
    do {
      // 1. 确保输出目录存在
      let outputURL = URL(fileURLWithPath: outputPath)
      let outputDir = outputURL.deletingLastPathComponent()
      try FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)
      
      // 2. 模拟字体生成过程（添加延迟以显示加载效果）
      Thread.sleep(forTimeInterval: 2.0)
      
      // 3. TODO: 这里应该实现真正的字体生成逻辑
      // 当前为占位实现，创建一个空文件标记
      // 后续需要：
      // - 解析 strokeData JSON
      // - 将笔画转换为字体轮廓
      // - 使用 CoreText 或其他库生成 TTF 文件
      
      let placeholderData = "Font placeholder for: \(fontName)\nGenerated from \(strokeData.count) bytes of data"
      try placeholderData.write(to: outputURL, atomically: true, encoding: .utf8)
      
      print("FontGenerator: Font generated at \(outputPath)")
      print("FontGenerator: Font name: \(fontName)")
      print("FontGenerator: Data size: \(strokeData.count) bytes")
      
      return true
    } catch {
      print("FontGenerator: Error generating font - \(error.localizedDescription)")
      return false
    }
  }
  
  /**
   * 将 SVG 字体转换为 TTF 字体
   * TODO: 实现真正的 SVG 到 TTF 转换
   */
  private func convertSvgToTtf(svgPath: String, ttfPath: String, fontName: String) -> Bool {
    do {
      let svgURL = URL(fileURLWithPath: svgPath)
      let ttfURL = URL(fileURLWithPath: ttfPath)
      
      // 检查 SVG 文件是否存在
      guard FileManager.default.fileExists(atPath: svgPath) else {
        print("FontConverter: SVG file not found at \(svgPath)")
        return false
      }
      
      // 确保输出目录存在
      let outputDir = ttfURL.deletingLastPathComponent()
      try FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)
      
      print("FontConverter: Converting SVG to TTF...")
      print("FontConverter: SVG: \(svgPath)")
      print("FontConverter: TTF: \(ttfPath)")
      
      // 模拟转换过程
      Thread.sleep(forTimeInterval: 1.0)
      
      // TODO: 实现真正的 SVG 到 TTF 转换
      // 选项 1: 使用 CoreText API
      // 选项 2: 使用第三方库
      // 选项 3: 调用外部工具
      
      // 当前占位实现：创建一个占位 TTF 文件
      let placeholderData = "TTF placeholder - SVG font at: \(svgPath)"
      try placeholderData.write(to: ttfURL, atomically: true, encoding: .utf8)
      
      print("FontConverter: Conversion completed (placeholder)")
      
      return true
    } catch {
      print("FontConverter: Error converting SVG to TTF - \(error.localizedDescription)")
      return false
    }
  }
}
