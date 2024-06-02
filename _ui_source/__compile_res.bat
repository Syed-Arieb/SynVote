@echo off
title Compiling resources...
echo Compiling Resources
pyside6-rcc qml.qrc -o ../qml/qml_rc.py
echo.
echo Done...
title Executing Script... 
echo.
echo Executing Script... 
cd ../
python main.py
echo.
pause > nul
exit