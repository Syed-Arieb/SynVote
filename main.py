import sys

from PySide6.QtCore import QUrl
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterSingletonType
from PySide6.QtQuickControls2 import QQuickStyle
import backend.synvote as svbe
from ui_bridge import SynBridge


import style_rc
from qml import qml_rc

qml_rc.qInitResources()


if __name__ == '__main__':
    app = QGuiApplication(sys.argv)
    QQuickStyle.setStyle("Material")

    # Register URLs
    FontUrl = QUrl("qrc:/FontStyle.qml")
    StyleUrl = QUrl("qrc:/AppStyle.qml")

    # Register singleton types
    qmlRegisterSingletonType(StyleUrl, "AppStyle", 1, 0, "AppStyle")
    qmlRegisterSingletonType(FontUrl, "AppStyle", 1, 0, "FontStyle")
    engine = QQmlApplicationEngine()

    # Get the path of the current directory, and then add the name
    # of the QML file, to load it.
    url = QUrl("qrc:/main.qml")
    engine.load(url)
    backend = svbe.SynVoteBackend()
    bridge = SynBridge(backend)
    engine.rootObjects()[0].setProperty('backend', bridge)

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())
