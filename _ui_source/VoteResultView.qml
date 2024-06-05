import QtQuick 2.15
import QtQuick.Controls 2.15
import QtCharts 2.7

Window {
    id: root
    
    width: 1280
    height: 720

    ChartView {
        title: "Line Chart"
        anchors.fill: parent
        antialiasing: true

        LineSeries {
            name: "Line"
            XYPoint { x: 0; y: 0 }
            XYPoint { x: 1.1; y: 2.1 }
            XYPoint { x: 1.9; y: 3.3 }
            XYPoint { x: 2.1; y: 2.1 }
            XYPoint { x: 2.9; y: 4.9 }
            XYPoint { x: 3.4; y: 3.0 }
            XYPoint { x: 4.1; y: 3.3 }
        }
    }
}