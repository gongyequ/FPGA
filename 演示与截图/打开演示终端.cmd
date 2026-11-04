@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo 视频演示目录已打开。
echo 依次运行：python 录制演示.py 命令
echo           python 录制演示.py 对比
echo           python 录制演示.py 九例
echo           python 录制演示.py 等价
cmd /k
