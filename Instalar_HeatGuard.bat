@echo off
title Instalador de Dependencias - HeatGuard
color 0b

echo ======================================================
echo           INSTALADOR PARA HEATGUARD v1.0
echo ======================================================
echo.
echo Verificando instalacion de Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python no esta instalado o no esta en el PATH.
    echo Por favor, instala Python antes de continuar.
    pause
    exit
)

echo [1/4] Actualizando pip...
python -m pip install --upgrade pip

echo [2/4] Instalando librerias cientificas (Numpy y Matplotlib)...
pip install numpy matplotlib --default-timeout=100

echo [3/4] Instalando framework de interfaz (Flet)...
pip install flet --upgrade

echo [4/4] Verificando instalacion final...
echo.
echo Librerias instaladas con exito.
echo.
echo ======================================================
echo   Configuracion completa. Ya puedes ejecutar HeatGuard.
echo ======================================================
pause
