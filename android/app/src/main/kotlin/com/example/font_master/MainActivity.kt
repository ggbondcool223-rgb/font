package com.example.font_master

import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
// import com.chaquo.python.Python  // Disabled - Chaquo Python temporarily removed
// import com.chaquo.python.android.AndroidPlatform

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.fontmaster/font_generator"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "generateFont" -> {
                        val strokeData = call.argument<String>("strokeData")
                        val fontName = call.argument<String>("fontName")
                        val outputPath = call.argument<String>("outputPath")

                        if (strokeData == null || fontName == null || outputPath == null) {
                            result.error("INVALID_ARGS", "Missing required arguments", null)
                            return@setMethodCallHandler
                        }

                        // 在后台线程生成字体
                        Thread {
                            val success = generateFont(strokeData, fontName, outputPath)
                            
                            // 回到主线程返回结果
                            Handler(Looper.getMainLooper()).post {
                                result.success(success)
                            }
                        }.start()
                    }
                    "convertSvgToTtf" -> {
                        val svgPath = call.argument<String>("svgPath")
                        val ttfPath = call.argument<String>("ttfPath")
                        val fontName = call.argument<String>("fontName")

                        if (svgPath == null || ttfPath == null || fontName == null) {
                            result.error("INVALID_ARGS", "Missing required arguments", null)
                            return@setMethodCallHandler
                        }

                        // 在后台线程转换字体
                        Thread {
                            val success = convertSvgToTtf(svgPath, ttfPath, fontName)
                            
                            // 回到主线程返回结果
                            Handler(Looper.getMainLooper()).post {
                                result.success(success)
                            }
                        }.start()
                    }
                    "checkAvailability" -> {
                        result.success(true)
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }

    /**
     * 生成字体文件（简化版本）
     * TODO: 完整实现需要集成 fontforge 或其他字体生成库
     */
    private fun generateFont(
        strokeData: String,
        fontName: String,
        outputPath: String
    ): Boolean {
        return try {
            // 1. 确保输出目录存在
            val outputFile = File(outputPath)
            outputFile.parentFile?.mkdirs()

            // 2. 模拟字体生成过程（添加延迟以显示加载效果）
            Thread.sleep(2000)

            // 3. TODO: 这里应该实现真正的字体生成逻辑
            // 当前为占位实现，创建一个空文件标记
            // 后续需要：
            // - 解析 strokeData JSON
            // - 将笔画转换为字体轮廓
            // - 使用字体库生成 TTF 文件
            
            // 临时创建一个标记文件
            outputFile.createNewFile()
            outputFile.writeText("Font placeholder for: $fontName\nGenerated from ${strokeData.length} bytes of data")

            android.util.Log.d("FontGenerator", "Font generated: $outputPath")
            android.util.Log.d("FontGenerator", "Font name: $fontName")
            android.util.Log.d("FontGenerator", "Data size: ${strokeData.length} bytes")

            true
        } catch (e: Exception) {
            android.util.Log.e("FontGenerator", "Error generating font", e)
            false
        }
    }

    /**
     * 将 SVG 字体转换为 TTF 字体
     * TODO: 重新实现 - Chaquopy Python 暂时被禁用
     * 
     * 可选方案：
     * 1. 使用服务器端 API 进行转换
     * 2. 使用纯 Kotlin/Java 的字体库
     * 3. 仅使用 SVG 字体格式
     */
    private fun convertSvgToTtf(
        svgPath: String,
        ttfPath: String,
        fontName: String
    ): Boolean {
        return try {
            val svgFile = File(svgPath)
            if (!svgFile.exists()) {
                android.util.Log.e("FontConverter", "SVG file not found: $svgPath")
                return false
            }

            android.util.Log.w("FontConverter", "SVG to TTF conversion is not available")
            android.util.Log.w("FontConverter", "Python/FontForge integration disabled due to compatibility issues")
            android.util.Log.i("FontConverter", "SVG font is available at: $svgPath")
            android.util.Log.i("FontConverter", "Consider using server-side conversion or alternative methods")

            // 暂时返回 false，表示 TTF 转换不可用
            // 应用将使用 SVG 字体格式
            false
        } catch (e: Exception) {
            android.util.Log.e("FontConverter", "Error in convertSvgToTtf", e)
            e.printStackTrace()
            false
        }
    }
}
