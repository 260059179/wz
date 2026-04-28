@echo off
chcp 936 >nul
title 正在下载插件列表，请稍候……

REM 字体颜色
color 0A

:: ====================== 固定配置（可自行修改）======================
:: 固定保存目录（可改成你想要的路径，比如 D:\九幽音频工作室）
set "saveDir=D:\九幽音频工作室"
:: 固定保存文件名（必须带后缀，如 .exe / .zip）
set "saveFileName=插件列表.exe"
:: 下载地址
set "插件列表Url=https://1818277977.v.123pan.cn/1818277977/27201522"
:: aria2 相关
set "workDir=%temp%\aria2-1.37.0-win-64bit-build1"
set "aria2cPath=%workDir%\aria2c.exe"
set "aria2Zip=%temp%\aria2.zip"
set "aria2Url=https://1818277977.v.123pan.cn/1818277977/29322796"
:: ==================================================================

:: 拼接最终固定文件路径
set "targetExe=%saveDir%\%saveFileName%"

:: 检查目标程序是否已存在
if exist "%targetExe%" (
    echo %saveFileName% 已存在，直接运行...
    start "" "%targetExe%"
    exit /b
)

:: 创建固定保存目录
if not exist "%saveDir%" mkdir "%saveDir%"

:: 检查aria2c是否存在
if not exist "%aria2cPath%" (
    echo aria2c 未找到，正在下载 aria2...
    powershell -Command "Invoke-WebRequest -Uri '%aria2Url%' -OutFile '%aria2Zip%' -UseBasicParsing"
    
    :: 解压aria2
    powershell -Command "Expand-Archive -Path '%aria2Zip%' -DestinationPath '%temp%' -Force"
    
    :: 删除临时zip文件
    del "%aria2Zip%" /q
)

:: 使用aria2c下载到固定路径
echo 正在下载 %saveFileName% ...
cd /d "%saveDir%"
"%aria2cPath%" "%插件列表Url%" -j8 -x8 --console-log-level=warn -o "%saveFileName%" --allow-overwrite=true

:: 运行程序
if exist "%targetExe%" (
    echo 下载完成，正在启动 %saveFileName% ...
    start "" "%targetExe%"
) else (
    echo 下载失败，请检查网络连接后重试。
    pause
)