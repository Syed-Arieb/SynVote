# Copyright (C) 2022 The Qt Company Ltd.
# SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

"""PySide6 port of the Pie Chart Example from Qt v5.x"""

import sys
from PySide6.QtCore import Qt
from PySide6.QtGui import QPainter, QPen, QFont, QBrush
from PySide6.QtWidgets import QMainWindow, QWidget, QApplication,QVBoxLayout
from PySide6.QtCharts import QChart, QChartView, QPieSeries


class VotingChart(QWidget):

    def __init__(self, data, room_id):
        super().__init__()
        font = QFont()
        font.setPointSize(16)  # Set the desired font size

        self.series = QPieSeries()

        for name, votes in data:
            slice = self.series.append(name, votes)
            slice.setLabelFont(font)
            slice.setLabelVisible(True)  # Set label visibility for each slice

        # Find the index of the slice with the maximum votes
        max_votes = max(data, key=lambda x: x[1])
        max_index = data.index(max_votes)

        # Explode the slice with the maximum votes
        self.explode_slice(max_index, Qt.darkGreen)

        self.chart = QChart()
        self.chart.addSeries(self.series)
        self.chart.setTitle(f'Voting Result of Room #{room_id}')

        # Increase the font size of the title
        font.setBold(True)
        self.chart.setTitleFont(font)

        self.chart.legend().hide()

        self._chart_view = QChartView(self.chart)
        self._chart_view.setRenderHint(QPainter.Antialiasing)

        layout = QVBoxLayout(self)
        layout.addWidget(self._chart_view)

    def explode_slice(self, index, color):
        slice = self.series.slices()[index]
        slice.setExploded()
        slice.setLabelVisible(True)
        slice.setPen(QPen(color, 2))
        slice.setBrush(QBrush(Qt.green))


if __name__ == "__main__":
    app = QApplication(sys.argv)

    data = [['Alice', 10], ['Bob', 7], ['Charlie', 3], ['David', 20], ['Eve', 21]]
    room_id = 3

    window = QMainWindow()
    window.setWindowTitle("Voting Result")
    widget = VotingChart(data, room_id)
    window.setCentralWidget(widget)
    window.resize(650, 600)
    window.show()

    sys.exit(app.exec())
