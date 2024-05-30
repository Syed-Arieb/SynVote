import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import AppStyle 1.0

Switch {
    id:control

    property color backgroundColor: AppStyle.popupBackground
    property color backgroundColorOn: AppStyle.appStyle

    property color indicatorColor: "#7a859b"
    property color indicatorColorOn: "#FFFFFF"

    property string indicatorOffSource: "qrc:/Images/sun2.svg"
    property string indicatorOnSource: "qrc:/Images/moon.svg"

    indicator: Rectangle{
        height: parent.height
        width: parent.width
        anchors.verticalCenter: control.verticalCenter
        radius: width/2
        color: control.checked ? backgroundColorOn : backgroundColor
        border.width: control.checked ? 2 : 1
        border.color: "#00000000"

        Behavior on color { ColorAnimation{} }

        Rectangle{
            x:control.checked ? (parent.width-width) - 3: 3
            width: parent.height - 6
            height: parent.height - 6
            radius: height/2
            color: control.checked ? indicatorColorOn : indicatorColor
            anchors.verticalCenter: parent.verticalCenter
            Behavior on color { ColorAnimation{} }

            Image {
                id: testImg
                source: control.checked ? indicatorOnSource : indicatorOffSource
                sourceSize: Qt.size(parent.width, parent.width)
                width: 2 * parent.width / 3
                height: 2 * parent.width / 3
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                fillMode: Image.PreserveAspectFit
                smooth: true
                antialiasing: false
            }

            Behavior on x { PropertyAnimation{} }
        }

        HoverHandler {
            id: mouse
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            cursorShape: Qt.PointingHandCursor
        }
    }

    contentItem: Label{
        id: textofcontrol
        color: "#FFFFFF"
        text: control.text
        font.pixelSize: FontStyle.h3
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
}
