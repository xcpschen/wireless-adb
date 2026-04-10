#!/bin/bash

echo "📱 获取完整的 logcat 日志..."
echo ""
echo "请在设备/模拟器上打开 Wireless ADB Switch 应用，等待应用闪退..."
echo "按 Ctrl+C 停止录制"
echo ""

# 清除之前的日志
/Users/chan/code/linkandroid/electron/resources/extra/osx-arm64/scrcpy/adb -s D5F7N19226000659 shell logcat -c

# 录制日志
/Users/chan/code/linkandroid/electron/resources/extra/osx-arm64/scrcpy/adb -s D5F7N19226000659 shell logcat -v threadtime > error_files/full_log.txt

echo ""
echo "日志已保存到 error_files/full_log.txt"
echo "使用以下命令查看错误信息："
echo "  grep -A 50 'AndroidRuntime' error_files/full_log.txt"
