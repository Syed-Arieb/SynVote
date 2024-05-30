import sys
from pathlib import Path

from PySide6.QtCore import QObject, Slot, QUrl, Signal, QTimer
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, QmlElement, qmlRegisterSingletonType
from PySide6.QtQuickControls2 import QQuickStyle
from time import strftime, localtime
from random import randint
import backend.synvote as svbe


class SynBridge(QObject):
    statusChanged = Signal(str, arguments=['msg'])

    def __init__(self, backend):
        super().__init__()

        self.syn_backend: svbe.SynVoteBackend = backend
        self.active_account = 0
        # Define timer.
        QTimer.singleShot(2000, self.update_status)

    def update_status(self):
        # Pass the current time to QML.
        d_addr = self.syn_backend.get_deployer()
        status_str = f'SynVote -> Contract Deployed by {d_addr}'
        self.statusChanged.emit(status_str)

    @Slot()
    def button_clicked(self):
        print("Button clicked in QML")
