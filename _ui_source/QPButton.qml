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
    property color foregroundColorHover: "#e5e5e5"
    property color foregroundColorClicked: "#e5e5e5"
    property color borderColor: "#00000000"
    property color borderColorClicked: "#00000000"
    property real corner_radius: 15
    property string iconSource: ""
    property color iconColor: "#ffffff"
    property bool isBold: false
    property int iconSize: 22

    width: textItem.x + textItem.width + 12
    height: 40
    leftPadding: 4
    rightPadding: 4
    text: ""
    antialiasing: true
    background: buttonBackground
    contentItem: Text {
        text: "igonre_test"
        width: 0
        height: 0
        color: "#00ffffff"
    }

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
                color: mouse.hovered ? foregroundColorHover : foregroundColor
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
        anchors.fill: parent
        opacity: enabled ? 1 : 0.3
        radius: corner_radius
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

    Rectangle {
        anchors.fill: parent
        color: "#00ffffff"
        IconImage {
            id: icon
            visible: iconSource == "" ? false : true
            source: iconSource
            sourceSize: Qt.size(iconSize, iconSize)
            color: iconColor
            width: visible ? iconSize : 0
            height: visible ? iconSize : 0
            x: 8
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: textItem
            x: icon.x + icon.width + 5
            text: control.text
            opacity: enabled ? 1 : 0.3
            color: "#047eff"
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: FontStyle.h3
            font.family: isBold ? FontStyle.getContentFontBold.name : FontStyle.getContentFont.name
            font.bold: isBold ? Font.Bold : Font.Normal
            font.weight: isBold ? Font.Bold : Font.Normal
        }
    }

    

    

    

}
