import sys

# PySide6 imports
from PySide6.QtCore import QUrl, QTimer
from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterSingletonType
from PySide6.QtQuickControls2 import QQuickStyle
from PySide6.QtWidgets import QApplication
import FeatherIconsQML

# Custom Libs
import backend.synvote as svbe
from ui_bridge import SynBridge
from qml import qml_rc

# Init Resources
qml_rc.qInitResources()

if __name__ == '__main__':
    app = QApplication(sys.argv)

    # Material Style
    QQuickStyle.setStyle("Material")

    # Backend
    backend = svbe.SynVoteBackend()
    
    # Set Icon
    icon = QIcon(":/Images/shield.svg")
    app.setWindowIcon(icon)

    # Register URLs
    FontUrl = QUrl("qrc:/FontStyle.qml")
    StyleUrl = QUrl("qrc:/AppStyle.qml")

    # Register singleton types
    qmlRegisterSingletonType(StyleUrl, "AppStyle", 1, 0, "AppStyle")
    qmlRegisterSingletonType(FontUrl, "AppStyle", 1, 0, "FontStyle")
    engine = QQmlApplicationEngine()
    FeatherIconsQML.register(engine)

    # Get the path of the current directory, and then add the name
    # of the QML file, to load it.
    url = QUrl("qrc:/main.qml")
    
    engine.load(url)
    bridge = SynBridge(backend)
    engine.rootObjects()[0].setProperty('backend', bridge)

#    QQmlApplicationEngine().load("qrc:/VoteResultView.qml")

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())
