@echo off
echo Compiling Resources
pyside6-rcc qml.qrc -o ../qml/qml_rc.py
echo