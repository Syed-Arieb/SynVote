import AppStyle 1.0
import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: control

    property bool isMouseOver: mouse.hovered
    property color backgroundColor: AppStyle.popupBackground
    property color backgroundColorClicked: "#cc33da"
    property color backgroundColorHover: "#7e3c8e"
    property color foregroundColor: "#e5e5e5"
    property color foregroundColorClicked: "#fbd2ff"
    property color borderColor: "#00000000"
    property color borderColorClicked: "#00000000"
    property bool isBold: false

    implicitWidth: 120
    implicitHeight: 60
    leftPadding: 4
    rightPadding: 4
    text: "GUI Guru"
    antialiasing: true
    background: buttonBackground
    contentItem: textItem
    states: [
        State {
            name: "normal"
            when: !control.down

            PropertyChanges {
                target: buttonBackground
                color: mouse.hovered ? backgroundColorHover : backgroundColor
                border.color: borderColor
            }

            PropertyChanges {
                target: textItem
                color: foregroundColor
            }

        },
        State {
            name: "down"
            when: control.down

            PropertyChanges {
                target: textItem
                color: foregroundColorClicked
            }

            PropertyChanges {
                target: buttonBackground
                color: backgroundColorClicked
                border.color: borderColorClicked
            }

        }
    ]

    Rectangle {
        id: buttonBackground

        color: mouse.hovered ? backgroundColorHover : backgroundColor
        implicitWidth: 100
        implicitHeight: 40
        opacity: enabled ? 1 : 0.3
        radius: 10
        border.color: borderColor

        HoverHandler {
            id: mouse

            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            cursorShape: Qt.PointingHandCursor
        }

        Behavior on color {
            ColorAnimation {
                duration: 200
            }

        }

    }

    Text {
        id: textItem

        text: control.text
        opacity: enabled ? 1 : 0.3
        color: "#047eff"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: FontStyle.h3
        font.family: isBold ? FontStyle.getContentFontBold.name : FontStyle.getContentFont.name
        font.bold: isBold ? Font.Bold : Font.Normal
        font.weight: isBold ? Font.Bold : Font.Normal
    }

}
